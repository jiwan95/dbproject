<%@ page contentType="text/html; charset=UTF-8" %>
<%
	boolean stu_mode = true;
	String session_id= (String)session.getAttribute("user");
	if(session_id == null) {
		session_id = (String)session.getAttribute("prof");
		if(session_id != null) stu_mode = false;
	}
	String log;
%>
<a href="main.jsp" style="display: inline;">home tag</a>
<table width="75%" align="center" id="top_nav">
	<tr>
	<td align="center"><b><a href="update.jsp" id="top_a">사용자 정보 수정</b></td>
<%	if( stu_mode == false ) {
%>
	<td align="center"><b><a href="insert.jsp" id="top_a">수업과목 추가</b></td>
	<td align="center"><b><a href="delete.jsp" id="top_a">수업과목 삭제</b></td>
	<td align="center"><b><a href="select.jsp" id="top_a">수업과목 조회</b></td>
<%  }
	else {
%>
	<td align="center"><b><a href="insert.jsp" id="top_a">수강과목 추가</b></td>
	<td align="center"><b><a href="delete.jsp" id="top_a">수강과목 삭제</b></td>
	<td align="center"><b><a href="select.jsp" id="top_a">수강과목 조회</b></td>
<%  }
%>
<%	if (session_id!=null){
		log="<a href=logout.jsp id=top_a> 로그아웃</a>";
%>
	<td align="center"><b><%=log%></b></td>
<%	}
%>
	</tr>
</table>