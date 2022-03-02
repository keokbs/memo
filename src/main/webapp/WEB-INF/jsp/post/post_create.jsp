<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="d-flex justify-content-center align-items-center" id="postCreate">
	<div class="w-50 table-font-color">
		<h1 class="mb-3">글쓰기</h1>
		<input type="text" name="subject" id="subject" class="form-control mb-2" placeholder="제목을 입력해주세요.">
		<textarea id="content" class="form-control" rows="10" cols="10" placeholder="내용을 입력해주세요."></textarea>
		<div class="d-flex justify-content-end mt-2">
			<input id="file" type="file" class="float-right" accpet=".gif,.jpg,.png,.jpeg">
		</div>
		<div class="d-flex justify-content-between mt-3 mb-3">
			<button type="button" id="postListBtn" class="btn create-btn2">목록</button>
			<div class="d-flex justify-content-end">
				<button type="button" id="clearBtn" class="btn btn-dark create-btn">모두지우기</button>
				<button type="button" id="saveBtn" class="btn btn-info create-btn ml-4">저장</button>
			</div>
		</div>
	</div>
</div>
<script>
$(document).ready(function() {
	$('#postListBtn').on('click', function() {
		location.href="/post/post_list_view"
	});
	$('#clearBtn').on('click', function() {
		// 제목과 내용 부분을 빈칸으로 세팅한다.
		$('#subject').val('');
		$('#content').val('');
	});
	
	// 글 내용 저장
	$('#saveBtn').on('click', function() {
		// validation - 제목만 필수
		let subject = $('#subject').val();
		let subjectVali = $('#subject').val().trim();
		if (subjectVali == ''){
			alert("제목을 입력해주세요.");
			return;
		}
		let content = $('#content').val();
		// console.log(content);
		
		// 파일이 업로드 된 경우 확장자 체크
		let file = $('#file').val();
		// alert(file);
		if (file != '') {
			let ext = file.split(".").pop().toLowerCase();
			// L 파일 경로를 . 으로 나누고 확장자가 있는 마지막 문자열을 가져온 후 모두 소문자로 통일
			if ($.inArray(ext, ['gif', 'jpg', 'png', 'jpeg']) == -1) { // 있으면 ture 없으면 -1로 나온다.
				alert("gif, jpg, png, jpeg 파일만 업로드 할 수 있습니다.");
				$('#file').val(''); // 파일을 비운다.
				return;
			}
		}
		
		// 파일을 보낼땐 무조건 폼 태그를 써야한다. 폼태그가 없다면 자바스크립트에서 임으로 만든다.
		let formData = new FormData();
		formData.append("subject", subject);
		formData.append("content", content);
		formData.append("file", $('#file')[0].files[0]);
		// L $(#'file')[0] 첫번째 input file ㅐ그를 의미, files[0]는 업로드 된 첫번째 파일을 의미
		
		// AJAX form 데이터 전송
		$.ajax({
			type: "post"
			, url: "/post/create"
			, data: formData
			, enctype: "multipart/form-data" // 파일 업로드를 위한 필수 설정
			, processData: false // 파일 업로드를 위한 필수 설정
			, contentType: false // 파일 업로드를 위한 필수 설정
			, success: function(data) {
				if (data.result == "success"){
					alert("저장되었습니다.");
					location.href="/post/post_list_view";				
				} else {
					alert(data.errorMessage);
					location.href="/user/sign_in_view";				
				}
			}
			, error: function(e) {
				alert("저장에 실패했습니다. 다시 한번 시도해주세요.");
			}
		});
	});
});

</script>

