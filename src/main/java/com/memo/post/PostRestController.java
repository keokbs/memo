package com.memo.post;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.memo.post.bo.PostBO;

@RequestMapping("/post")
@RestController
public class PostRestController {
	
	@Autowired
	private PostBO postBO;
	
	// 테스트용 컨트롤러
//	@RequestMapping("/posts")
//	public List<Post> posts() {
//		List<Post> postList = postBO.getPostList();
//		return postList;
//	}

	/**
	 * 글쓰기
	 * @param subject
	 * @param content
	 * @param file
	 * @param request
	 * @return
	 */
	@PostMapping("/create")
	public Map<String, Object> create(
			@RequestParam("subject") String subject,
			@RequestParam(value="content", required=false) String content,
			@RequestParam(value="file", required=false) MultipartFile file,
			HttpServletRequest request
			) {
		Map<String, Object> result = new HashMap<>();
		result.put("result", "success");
		
		// 글쓴이의 정보를 가져온다.
		HttpSession session = request.getSession();
		Integer userId = (Integer)session.getAttribute("userId"); // null 일수도 있기 때문에 Integer로 만든다.
		String userLoginId = (String)session.getAttribute("userLoginId");
		if(userId == null) {
			// 로그인 되어있지 않음
			result.put("result", "error");
			result.put("errorMessage", "로그인 후 사용할 수 있습니다.");
			return result;
		}
		
		// userId, userLoginId, subject, content, file => BO insert 요청
		postBO.addPost(userId, userLoginId, subject, content, file);
		
		return result;
	}
	
	@PutMapping("/update")
	public Map<String, Object> update(
			@RequestParam("postId") int postId,
			@RequestParam("subject") String subject,
			@RequestParam(value="content", required=false) String content,
			@RequestParam(value="file", required=false) MultipartFile file,
			HttpServletRequest request
			) {
		HttpSession session = request.getSession();
		String userLoginId = (String)session.getAttribute("userLoginId");
		int userId = (int)session.getAttribute("userId"); // null이면 업데이트가 안됨.
		
		Map<String, Object> result = new HashMap<>();
		result.put("result", "success");
		
		// update DB
		int row = postBO.updatePost(postId, userLoginId, userId, subject, content, file);
		if (row < 1) {
			result.put("result", "error");
			result.put("errorMassage", "메모 수정에 실패했습니다.");
		}
		
		return result;
	}
}