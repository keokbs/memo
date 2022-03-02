package com.memo.post.bo;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.memo.common.FileManagerService;
import com.memo.post.dao.PostDAO;
import com.memo.post.model.Post;

@Service
public class PostBO {
	
	// private Logger logger = LoggerFactory.getLogger(PostBO.class);
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private PostDAO postDAO;
	
	@Autowired
	private FileManagerService fileManager;
	
	public List<Post> getPostListByUserId(int userId) {
		return postDAO.selectPostListByUserId(userId);
	}
	
	public Post getPostById(int id) {
		return postDAO.selectPostById(id);
	}
	
	
	// userId, subject, content, file
	public void addPost(
			int userId, 
			String userLoginId, 
			String subject, 
			String content, 
			MultipartFile file) {
		String imagePath = null;
		if(file != null) {
			// TODO : 파일 매니저 서비스 input:MultipartFile	output:이미지의 주소
			imagePath = fileManager.saveFile(userLoginId, file);
		}
		
		// insert DAO
		postDAO.insertPost(userId, subject, content, imagePath);
		
	}
	
	public int updatePost(
			int postId, String userLoginId, int userId, 
			String subject, String content, MultipartFile file) {
		// logger.error("에러 로깅 테스트");

		// postId에 해당하는 게시글이 있는지 DB에서 가져와본다.
		Post post = getPostById(postId);
		if (post == null) {
			logger.error("[update post] 수정할 메모가 존재하지 않습니다." + postId);
			return 0;
		}
		
		// 게시글이 있을때 파일이 있는지 본 후 서버에 업로드하고 image path 받아온다.
		// 파일이 없다면 수정하지 않는다.
		String imagePath = null;
		if (file != null) {
			imagePath = fileManager.saveFile(userLoginId, file); // 컴퓨터에 파일 업로드 후 URL Path를 얻는다.
			
			// 새로 업로드된 이미지가 성공하면 기존 이미지 삭제(기본 이미지가 존재할때만)
			// 기존 이미지가 있고, 새로운 이미지도 존재할 때 
			if(post.getImagePath() != null && imagePath != null) {
				// 기존 이미지 삭제
				fileManager.deleteFile(post.getImagePath());
				
			}
		}
		
		// DB 업데이트
		return postDAO.updatePostByUserIdAndPostId(userId, postId, subject, content, imagePath);
		
	}
}
