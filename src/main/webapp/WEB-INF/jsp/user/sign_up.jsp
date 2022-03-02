<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="d-flex justify-content-center align-items-center h-100">
	<div class="font-color">
		<form id="signUpForm" method="post" action="/user/sign_up">
			<div class="d-flex justify-content-center">
				<table class="table-bordered table-font-size">
					<tr class="table-height-tr1">
						<th class="table-color table-width text-center" bgcolor="#d18063">* 아이디</th>
						<td class="table-width" bgcolor="#fff">
							<div>
								<div class="d-flex mb-1">
									<input type="text" id="loginId" name="loginId" class="form-control col-7 ml-3 sign_up_input">
									<button type="button" id="duplicateBtn" class="myBtn ml-2 btn">중복확인</button>
								</div>
								<div id="idCheckLength" class="small d-none text-danger ml-3 d-none">아이디를 4자 이상 적어주세요.</div>
								<div id="idAvailable" class="small text-success ml-3 d-none">사용 가능한 아이디 입니다.</div>
								<div id="idDuplication" class="small text-danger ml-3 d-none">중복된 아이디 입니다.</div>
							</div>
						</td>
					</tr>
					<tr class="table-height-tr2">
						<th class="table-width text-center" bgcolor="#d18063">* 비밀번호</th>
						<td class="table-width" bgcolor="#fff">
							<input type="password" id="password" name="password" class="form-control sign_up_input col-7 ml-3">
						</td>
					</tr>
					<tr class="table-height-tr2">
						<th class="table-width text-center" bgcolor="#d18063">* 비밀번호 확인</th>
						<td class="table-width" bgcolor="#fff">
							<input type="password" id="passwordCheck" name="passwordCheck" class="form-control sign_up_input col-7 ml-3">
						</td>
					</tr>
					<tr class="table-height-tr2">
						<th class="table-width text-center" bgcolor="#d18063">* 이름</th>
						<td class="table-width" bgcolor="#fff">
							<input type="text" id="name" name="name" class="form-control sign_up_input col-7 ml-3" placeholder="이름을 입력하세요">
						</td>
					<tr  class="table-height-tr2">
						<th class="table-width text-center" bgcolor="#d18063">* 이메일 주소</th>
						<td class="table-width" bgcolor="#fff">
							<input type="text" id="email" name="email" class="form-control sign_up_input col-10 ml-3" placeholder="이메일 주소를 입력하세요">
						</td>			
					</tr>
				</table>
			</div>
			<div class="d-flex justify-content-end mt-4">
				<button type="submit" class="sign_up_btn" id="sign_up_btn">회원가입</button>
			</div>
		</form>
	</div>
</div>

<script>
$(document).ready(function() {
	// 아이디 중복 확인
	$("#duplicateBtn").on('click', function() {
		// alert("ok?");
		let loginId = $('#loginId').val().trim();
		
		// 상황 문구 안보이게 모두 초기화
		$('#idCheckLength').addClass('d-none');
		$('#idAvailable').addClass('d-none');
		$('#idDuplication').addClass('d-none');
		
		if (loginId.length < 4) {
			// id가 4자 미만일 때 경고 문구 노출하고 끝낸다.
			$('#idCheckLength').removeClass('d-none');
			return;
		}
		$.ajax({
			url: "/user/id_duplicated_id"
			, data: {"loginId": loginId}
			, success: function(data) {
				if (data.result) {
					// 중복인 경우 -> 이미 사용중인 아이디
					$('#idDuplication').removeClass('d-none');
				} else if (data.result == false){ 
					// 아닌경우 -> 사용 가능한 아이디
					$('#idAvailable').removeClass('d-none');
				} else {
					// 에러
				}
			}
			, error: function(e) {
				alert("아이디 중복 확인을 실패했습니다.");
			}
		});
	});
	
	// 회원 가입
	$('#signUpForm').on('submit', function(e) {
		e.preventDefault();
		
		// validation check
		let loginId = $('#loginId').val().trim();
		if (loginId == ''){
			alert("아이디를 입력해주세요.");
			return false;
		}
		
		let password = $('#password').val().trim();
		let passwordCheck = $('#passwordCheck').val().trim();
		
		if (password == '' || passwordCheck == ''){
			alert("비밀번호를 입력해주세요.");
			return false;
		}
		
		if (password != passwordCheck){
			alert("비밀번호가 일치하지 않습니다.");
			// 비밀번호 텍스트 초기화
			$('#password').val('');
			$('#passwordCheck').val('');
			return false;
		}
		
		
		let name = $('#name').val().trim();
		if (name == ''){
			alert("이름을 입력해주세요.");
			return false;
		}
		
		let email = $('#email').val().trim();
		if (email == ''){
			alert("이메일주소를 입력해주세요.");
			return false;
		}
		
		// 아이디 중복확인이 되었는지 확인
		// idAvailable <div>에 클래스 중 d-none이 있는 경우 => 성공이 아님 =? alert 띄우고 return 시킴 (회원가입 X)
		if ($('#idAvailable').hasClass('d-none')) {
			alert("아이디 중복 확인을 해주세요.");
			return;
		}
		
		// submit (this = #signUpForm)
		// 1. form 서브밋 => 응답이 화면이 됨
		// 2. ajax 서브밋
		
		// 1. form 서브밋
		// $(this)[0].submit(); // 화면이 이동될때 e.preventDefault(); 있을 때 서브밋
		
		// 2. ajax 서브밋
		let url = $(this).attr('action'); // form 태그의 action 주소(view가 아닌 api의 응닶이 내려오는 주소)를 가져오는 법
		let params = $(this).serialize(); // 폼태그에 있는 name 속성의 값을 한번에 보낼 수 있게 구성한다.
		// console.log(params);

		$.post(url, params)
		.done(function(data) {
			if (data.result == 'success') {
				alert("회원 가입이 되었습니다.");
				location.href = "/user/sign_in_view";
			} else {
				alert("회원 가입에 실패했습니다. 다시 시도해주세요.");
				
			}
		});
		
	
	});
});
</script>