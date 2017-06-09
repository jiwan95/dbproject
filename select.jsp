<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel='stylesheet' href='./dbDesign.css' />
</head>
<body>
	<%@ include file="/top.jsp" %>
	<br/>
	<br/>
	<br/>
	<table id="select_table">
		<tr>
			<td>과목</td>
			<td>분반</td>
			<td>과목명</td>
			<td>교수</td>
			<td>시간</td>
			<td>장소</td>
			<td>학점</td>
		</tr>
<%
	Calendar system_date = Calendar.getInstance();
	int form_year = system_date.get(Calendar.YEAR);
	int form_semester;
	if (system_date.get(Calendar.MONTH) <= 7)
		form_semester = 1;
	else
		form_semester = 2;
	String course_id;
	int course_id_no;
	String course_name = "";
	int course_unit = 0;
	String professor_id = "";
	String professor_name = "";
	String int_course_day = "";
	String str_course_day = "";
	String course_start_time = "";
	String course_end_time = "";
	String course_place = "";
	
	int total_course = 0;
	int total_unit = 0;
	
	Connection conn = null;		
	PreparedStatement pstmt = null;
	CallableStatement cstmt = null; 
	ResultSet rs = null;
	ResultSet sub_rs = null;
	String sql;
	String sub_sql;
	
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";        
	String user = "db01";                                       
	String passwd = "ss2";
	
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");            
		conn = DriverManager.getConnection(dburl, user, passwd);
		
		sql = "SELECT c_id, c_id_no FROM enroll WHERE s_id = ? and e_year = ? and e_semester = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, session_id);
		pstmt.setInt(2, form_year);
		pstmt.setInt(3, form_semester);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			course_id = rs.getString("c_id");
			course_id_no = rs.getInt("c_id_no");
			
			sub_sql = "SELECT c_name, c_unit FROM course WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				course_name = sub_rs.getString("c_name");
				course_unit = sub_rs.getInt("c_unit");
				total_unit = total_unit + course_unit;
				total_course++;
			}
			
			sub_sql = "SELECT p_id, t_day, t_startTime_HH, t_startTime_MM, t_endTime_HH, t_endTime_MM, t_where FROM teach WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				professor_id = sub_rs.getString("p_id");
				int_course_day = "" + sub_rs.getInt("t_day");
				course_start_time = "" + sub_rs.getInt("t_startTime_HH");
				course_start_time = course_start_time + " : " + sub_rs.getInt("t_startTime_MM");
				course_end_time = "" + sub_rs.getInt("t_endTime_HH");
				course_end_time = course_end_time + " : " + sub_rs.getInt("t_endTime_MM");
				course_place = sub_rs.getString("t_where");
			}
			
			sub_sql = "SELECT p_name FROM professor WHERE p_id = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, professor_id);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next())
				professor_name = sub_rs.getString("p_name");
%>
		<tr>
			<td><%=course_id %></td>
			<td><%=course_id_no %></td>
			<td><%=course_name %></td>
			<td><%=professor_name %></td>
<%
			sql = "{? = call getStrDay(?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, int_course_day);
			cstmt.execute();
			str_course_day = cstmt.getString(1);
%>
			<td><%=str_course_day %> <%=course_start_time %> - <%=course_end_time %></td>
			<td><%=course_place %></td>
			<td><%=course_unit %></td>
		</tr>
<%
		}
		
		sub_rs.close();
		rs.close();
		pstmt.close();
		conn.close();
	} 
	catch(SQLException ex) { 
	}
%>
		<tr>
			<td>현재까지 <%=total_course %>과목, 총 <%=total_unit %>학점 수강신청 했습니다</td>
		</tr>
	</table>
</body>
</html>