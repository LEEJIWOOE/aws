<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.util.Date" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // 디버깅: 받은 값 출력
    System.out.println("========== 로그인 시도 ==========");
    System.out.println("Username: [" + username + "]");
    System.out.println("Username length: " + (username != null ? username.length() : "null"));
    System.out.println("Password: [" + password + "]");
    System.out.println("Password length: " + (password != null ? password.length() : "null"));
    
    // 사용자별 세션 번호 매핑
    Map<String, Integer> userSessionMap = new HashMap<>();
    userSessionMap.put("jiwoo", 1);
    userSessionMap.put("jiwoo2", 2);
    
    // 간단한 인증
    boolean isValid = false;
    
    // 공백 제거
    if (username != null) username = username.trim();
    if (password != null) password = password.trim();
    
    if (username != null && userSessionMap.containsKey(username) && "password".equals(password)) {
        isValid = true;
        System.out.println("✅ 인증 성공!");
    } else {
        System.out.println("❌ 인증 실패!");
        System.out.println("- username이 null인가? " + (username == null));
        System.out.println("- 입력된 username: [" + username + "]");
        System.out.println("- userSessionMap에 있는가? " + userSessionMap.containsKey(username));
        System.out.println("- 가능한 사용자명: " + userSessionMap.keySet());
        System.out.println("- password가 맞는가? " + "password".equals(password));
        System.out.println("- 입력된 password: [" + password + "]");
    }
    
    if (isValid) {
        // 세션에 사용자 정보 저장
        session.setAttribute("username", username);
        session.setAttribute("sessionNumber", userSessionMap.get(username));
        session.setAttribute("loginTime", System.currentTimeMillis());
        
        System.out.println("세션에 정보 저장 완료");
        System.out.println("Session ID: " + session.getId());
        System.out.println("Session Number: " + userSessionMap.get(username));
        
        // EFS에 세션 정보 저장
        try {
            String efsPath = "/mnt/efs/session";
            File sessionDir = new File(efsPath);
            
            // 디렉토리가 없으면 생성
            if (!sessionDir.exists()) {
                boolean created = sessionDir.mkdirs();
                System.out.println("EFS 디렉토리 생성 시도: " + created);
                
                if (!created) {
                    System.err.println("❌ EFS 디렉토리 생성 실패: " + efsPath);
                    System.err.println("권한을 확인하세요: sudo chown tomcat:tomcat /mnt/efs");
                }
            }
            
            // 디렉토리 쓰기 권한 확인
            if (!sessionDir.canWrite()) {
                System.err.println("❌ EFS 디렉토리 쓰기 권한 없음: " + efsPath);
            }
            
            Integer sessionNumber = userSessionMap.get(username);
            File sessionFile = new File(efsPath + "/session_" + sessionNumber + ".txt");
            
            try (PrintWriter writer = new PrintWriter(new FileWriter(sessionFile))) {
                writer.println("Session ID: " + session.getId());
                writer.println("Username: " + username);
                writer.println("Session Number: " + sessionNumber);
                writer.println("Login Time: " + new Date(session.getCreationTime()));
                writer.println("Last Access: " + new Date(session.getLastAccessedTime()));
                writer.println("Server: " + request.getServerName());
            }
            System.out.println("✅ EFS 파일 저장 완료: " + sessionFile.getAbsolutePath());
        } catch (IOException e) {
            System.err.println("❌ EFS 저장 오류: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("dashboard.jsp로 리다이렉트");
        // 대시보드로 리다이렉트
        response.sendRedirect("dashboard.jsp");
    } else {
        // 로그인 실패
        System.out.println("index.jsp?error=1로 리다이렉트");
        response.sendRedirect("index.jsp?error=1");
    }
    
    System.out.println("==================================");
%>
