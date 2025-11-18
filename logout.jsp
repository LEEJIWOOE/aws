<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%
    // 세션에서 정보 가져오기
    Integer sessionNumber = (Integer) session.getAttribute("sessionNumber");
    
    // EFS 세션 파일에 로그아웃 시간 기록 (삭제하지 않음)
    if (sessionNumber != null) {
        try {
            String efsPath = "/mnt/efs/session";
            File sessionFile = new File(efsPath + "/session_" + sessionNumber + ".txt");
            
            if (sessionFile.exists()) {
                // 로그아웃 시간 추가 기록
                try (java.io.FileWriter fw = new java.io.FileWriter(sessionFile, true);
                     java.io.PrintWriter writer = new java.io.PrintWriter(fw)) {
                    writer.println("Logout Time: " + new java.util.Date());
                }
                
                // 파일 삭제를 원하면 아래 주석 해제
                // sessionFile.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 세션 무효화
    session.invalidate();
    
    // 로그인 페이지로 리다이렉트
    response.sendRedirect("index.jsp");
%>
