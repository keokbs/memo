package com.memo.common;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component // 스프링 빈
public class FileManagerService {
	
	// 회사에서는 CDN 서버에 저장(이미지, css, js)
	
	public final static String FILE_UPLOAD_PATH = "C:\\김혜주\\6_spring-project\\memo\\workspace\\images/";
	
	public String saveFile(String userLoginId, MultipartFile file) {
		// 파일 디렉토리(폴더) 경로 예 : keokbs_16456453342/sun.png
		// 파일명이 겹치지 않게 하기위해 현재시간을 경로에 붙여준다.
		String directoryName = userLoginId + "_" + System.currentTimeMillis() + "/";
		String filePath = FILE_UPLOAD_PATH + directoryName;
		
		// 디렉토리 만들기
		File directory = new File(filePath);
		if (directory.mkdir() == false) {
			return null; // 디렉토리 생성 시 실패하면 null 리턴
		}
		
		// 파일 업로드 : byte 단위로 업로드 한다.
		try {
			byte[] bytes = file.getBytes();
			Path path = Paths.get(filePath + file.getOriginalFilename()); 
			// L getOriginalFilename()는 input에서 올린 파일명이다.(한글X)
			Files.write(path, bytes);
			
			// 이미지 URL을 리턴한다. (WebMvcConfig에서 매핑한 이미지 path)
			// 예) http://localhost/images/keokbs_1645684229239/1bab7d5837aed31f.png

			return "/images/" + directoryName + file.getOriginalFilename();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}

	public void deleteFile(String imagePath) {
		// imagePath의 /images/keokbs_16456453342/sun.png 에서 /images/를 제거한 path를 실제 저장경로
		// C:\김혜주\6_spring-project\memo\workspace\images/  +  keokbs_16456453342/sun.png
		// 파일 삭제
		Path path = Paths.get(FILE_UPLOAD_PATH + imagePath.replace("/images/", ""));
		if(Files.exists(path)) {
			try {
				Files.delete(path);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		// 디렉토리(폴더) 삭제
		path = path.getParent();
		if (Files.exists(path)) {
			try {
				Files.delete(path);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
}
