<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="d-flex justify-content-center align-items-center" id="postCreate">
	<div class="w-50 table-font-color">
		<h1 class="mb-3">글상세</h1>
		<input type="text" name="subject" id="subject" class="form-control mb-2" value="${post.subject}">
		<textarea id="content" class="form-control" rows="10" cols="10">${post.content}</textarea>
		<div class="d-flex justify-content-end mt-2">
			<input id="file" type="file" class="float-right" accept=".gif, .jpg, .png, .jpeg">
		</div>
		<%-- 이미지가 있을 때만 이미지 영역 추가 --%>
		<c:if test="${not empty post.imagePath}">
			<div class="image-area">
				<img src="${post.imagePath}" alt="업로드 이미지" width="300">
			</div>
		</c:if>
		
		<div class="d-flex justify-content-between mt-3 mb-3">
			<button type="button" id="postDeleteBtn" class="btn btn-secondary create-btn">삭제</button>
			
			<div class="d-flex justify-content-end">
				<button type="button" id="postListBtn" class="btn create-btn2">목록</button>
				<button type="button" id="saveBtn" class="btn btn-info create-btn ml-3" data-post-id="${post.id}">저장</button>
			</div>
		</div>
	</div>
</div>

<script>
$(document).ready(function() {
	// 목록 버튼 클릭
	$('#postListBtn').on('click', function() {
		location.href="/post/post_list_view";
	});
	
	// 수정 저장버튼 클릭
	$('#saveBtn').on('click', function() {
		// validation check
		let subject = $('#subject').val().trim();
		let content = $('#content').val()
		if (subject == '') {
			alert("제목을 입력해주세요.")
			return;
		}
		
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
		
		// 폼 태그 객체를 자바스크립트에서 만든다.
		let formData = new FormData();
		let postId = $(this).data('post-id');
		console.log(postId);
		formData.append("postId", postId);
		formData.append("subject", subject);
		formData.append("content", content);
		formData.append("file", $('#file')[0].files[0]);
		
		// ajax
		$.ajax({
			method: "put"
			, url: "/post/update"
			,data: formData
			, enctype: 'multipart/form-data' // 파일 업로드를 위한 필수 설정
			, processData: false // 파일 업로드를 위한 필수 설정
			, contentType: false // 파일 업로드를 위한 필수 설정
			, success: function(data) {
				if (data.result == "success") {
					alert("메모가 수정되었습니다.")					
					location.reload();
				} else {
					alert(data.errorMassage);
				}
			}
			, error: function(e) {
				alert("저장에 실패했습니다. 관리자에게 문의해주세요.");
			}
		});
	});
});
</script>