<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="h-100 d-flex align-items-center justify-content-around"> 
	<div>
		<h1 class="logo font-color">메모 게시판</h1>
	</div>
	<div>
		<%-- 세션이 있을때만(로그인이 되었을 때만) 출력--%>
		<c:if test="${not empty userName}">
			<div>
				<span class="font-color">${userName}님 안녕하세요.</span>
				<a href="/user/sign_out" class="ml-3 font-color font-weight-bold">로그아웃</a>
			</div>
		</c:if>
	</div>
</div>

