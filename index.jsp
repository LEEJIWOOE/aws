    <h2><d83d><dd10> 로그인</h2>
        <form method="post" action="login_process.jsp">
            <input type="text" name="username" placeholder="사용자명 (jiwoo 또는 jiwoo2)" required>
            <input type="password" name="password" placeholder="비밀번호 (password)" required>
            <input type="submit" value="로그인">
        </form>

        <%
        String error = request.getParameter("error");
        if (error != null) {
        %>
            <p class="error">❌  로그인 실패: 사용자명 또는 비밀번호를 확인하세요</p>
        <% } %>

        <div class="info">
            <strong>테스트 계정:</strong><br>
            <d83d><dc64> jiwoo / password (세션 1번)<br>
            <d83d><dc64> jiwoo2 / password (세션 2번)
        </div>
    </div>
</body>
</html>
