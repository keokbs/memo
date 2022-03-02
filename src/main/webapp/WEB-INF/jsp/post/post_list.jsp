<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="d-flex justify-content-center align-items-center">
	<div class="table-font-color h-100 w-50">
		<h1 class="mt-3 mb-3">글 목록</h1>
		<table class="table table-hover table-font-color text-center">
			<thead>
				<tr>
					<th class="col-2">번호</th>
					<th class="col-5">제목</th>
					<th>작성날짜</th>
					<th>수정날짜</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${postList}" var="post">
					<tr>
						<td>${post.id}</td>
						<td><a href="/post/post_detail_view?postId=${post.id}">${post.subject}</a></td>
						<td>
							<fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
						</td>
						<td>
							<fmt:formatDate value="${post.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" />
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="float-right">
			<a href="/post/post_create_view" class="btn sign_up_btn">글쓰기</a>
		</div>
	</div>
</div>