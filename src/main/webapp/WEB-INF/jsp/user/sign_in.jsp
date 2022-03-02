<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="d-flex justify-content-center align-items-center h-100">
	<div class="font-color">
		<form id="loginForm" action="/user/sign_in" method="post">
			<div class="input-group mb-2">
			 	<span class="input-group-text" id="basic-addon3">ID</span>
			 	<input type="text" id="loginId" name="loginId" class="form-control" aria-describedby="basic-addon3">
			</div>
			<div class="input-group mb-3">
			 	<span class="input-group-text" id="basic-addon3">Password</span>
			 	<input type="password" id="password" name="password" class="form-control" aria-describedby="basic-addon3">
			</div>
			<div class="mb-2">
				<button type="submit" class="sign_in_btn" id="login_btn">로그인</button>
			</div>
			<div class="mb-2">
				<button type="button" class="sign_in_btn" id="sign_up_btn">회원가입</button>
				<%-- <a class="btn sign_in_btn" href="/user/sign_up_view">회원가입</a> --%>
			</div>
		</form>
	</div>
</div>
<script>
$(document).ready(function() {
	// alert("ok?");
	
	$('#sign_up_btn').on('click', function(e) {
		location.href = "/user/sign_up_view"
	});
	
	$('#loginForm').on('submit', function(e) {
		e.preventDefault(); // submit 기능 중단
		// $(this)[0].submit(); 서브밋 하거나 ajax 사용
		
		// validation Check
		let loginId = $('#loginId').val().trim();
		let password = $('#password').val();
		
		if (loginId.length < 1) {
			alert("아이디를 입력해주세요.");
			return false;
		}
		
		if (password.length < 1) {
			alert("비밀번호를 입력해주세요.");
			return false;
		}
		
		let url = $(this).attr('action'); // form에 있는 action주소를 가져옴.
		let params = $(this).serialize();
		
		$.post(url, params)
		.done(function(data) {
			if (data.result == 'success') {
				// 로그인 성공일 때 글 목록으로 이동
				location.href = "/post/post_list_view";
			} else {
				alert(data.errorMessage);
			}
		});
		
	});
	
});
</script>