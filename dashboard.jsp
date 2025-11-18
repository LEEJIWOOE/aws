<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.Date" %>
<%
    // 세션 체크
    String username = (String) session.getAttribute("username");
    Integer sessionNumber = (Integer) session.getAttribute("sessionNumber");
    
    if (username == null || sessionNumber == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대시보드</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f0f0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
        }
        .session-info {
            background: #e8f5e9;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .session-info p {
            margin: 10px 0;
            font-size: 16px;
        }
        .session-number {
            font-size: 48px;
            color: #4CAF50;
            font-weight: bold;
        }
        .logout-btn {
            background: #f44336;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        .logout-btn:hover {
            background: #da190b;
        }
        .efs-status {
            background: #fff3cd;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>환영합니다, <%= username %>님! 👋</h1>
        
        <div class="session-info">
            <h2>세션 정보</h2>
            <p>세션 번호: <span class="session-number"><%= sessionNumber %></span></p>
            <p>세션 ID: <%= session.getId() %></p>
            <p>세션 저장소: <strong>Redis + EFS</strong></p>
            <p>로그인 시간: <%= new Date(session.getCreationTime()) %></p>
            <p>마지막 접근: <%= new Date(session.getLastAccessedTime()) %></p>
            <p>세션 타임아웃: <%= session.getMaxInactiveInterval() %>초</p>
        </div>
        
        <%
            // EFS 세션 파일 읽기
            String efsPath = "/mnt/efs/session";
            File sessionFile = new File(efsPath + "/session_" + sessionNumber + ".txt");
            
            if (sessionFile.exists()) {
        %>
        <div class="efs-status">
            <h3>📁 EFS 저장 상태</h3>
            <pre><%
                try (BufferedReader reader = new BufferedReader(new FileReader(sessionFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        out.println(line);
                    }
                } catch (IOException e) {
                    out.println("세션 파일 읽기 오류: " + e.getMessage());
                }
            %></pre>
        </div>
        <% } %>
        
        <a href="logout" class="logout-btn">로그아웃</a>
    </div>
</body>
</html>
