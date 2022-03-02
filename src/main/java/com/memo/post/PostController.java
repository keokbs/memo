package com.memo.post;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.memo.post.bo.PostBO;
import com.memo.post.dao.PostDAO;
import com.memo.post.model.Post;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	private PostBO postBO;
	
	/**
	 * 글 목록 화면
	 * @param model
	 * @return
	 */
	@RequestMapping("/post_list_view")
	public String post_list_view(Model model, HttpServletRequest request) {
		// 글쓴이 정보를 가져오기 위해 세션에서 userId를 꺼낸다.
		HttpSession session = request.getSession();
		int userId = (int)session.getAttribute("userId");
		
		// TODO : 글 목록 DB에 가져오기
		List<Post> postList = postBO.getPostListByUserId(userId);
		// model 객체에 담긴
		model.addAttribute("postList", postList);
		model.addAttribute("viewName", "post/post_list");
		return "template/layout";
	}
	/**
	 * 글쓰기 화면
	 * @param model
	 * @return
	 */
	@RequestMapping("/post_create_view")
	public String post_create_view(Model model) {
		model.addAttribute("viewName", "post/post_create");
		return "template/layout";
	}
	
	@RequestMapping("/post_detail_view")
	public String postDetailView(
			@RequestParam("postId") int postId,
			Model model) {
		
		// postId에 해당하는 글을 가져옴
		Post post = postBO.getPostById(postId);
		
		model.addAttribute("post", post);
		model.addAttribute("viewName", "post/post_detail");
		return "template/layout";
	}
	
}
