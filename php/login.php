<?php
session_start();
require 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Look for username in both email and full_name columns
    $stmt = $pdo->prepare("SELECT * FROM Users WHERE email = :username OR full_name = :username");
    $stmt->execute(['username' => $username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($password, $user['password_hash'])) {
        $_SESSION['user_id'] = $user['user_id'];
        $_SESSION['role'] = $user['role'];

        // Remember me functionality (Optional)
        if (isset($_POST['rememberMe'])) {
            $token = bin2hex(random_bytes(16));  // Generate a random token
            setcookie('remember_token', $token, time() + (60 * 60 * 24 * 30), "/");
            $pdo->prepare("UPDATE Users SET remember_token = :token WHERE user_id = :user_id")
                ->execute(['token' => $token, 'user_id' => $user['user_id']]);
        }

        echo json_encode(['success' => true]);
        exit();
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid username or password']);
        exit();
    }
}
?>
