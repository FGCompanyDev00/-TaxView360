<?php
session_start();
require 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $fullName = $_POST['fullName'];
    $email = $_POST['email'];
    $password = $_POST['registerPassword'];
    $confirmPassword = $_POST['confirmPassword'];
    $agreeTerms = isset($_POST['agreeTerms']);

    if ($password !== $confirmPassword) {
        $_SESSION['register_error'] = 'Passwords do not match';
        header("Location: index.php");  // Redirect back to the registration page
        exit();
    }

    // Check if the email is unique
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM Users WHERE email = :email");
    $stmt->execute(['email' => $email]);
    $userCount = $stmt->fetchColumn();

    if ($userCount > 0) {
        $_SESSION['register_error'] = 'Email already exists';
        header("Location: index.php");
        exit();
    }

    // Hash the password using bcrypt
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    // Insert the new user into the database
    $stmt = $pdo->prepare("INSERT INTO Users (full_name, email, password_hash, role, status) VALUES (:full_name, :email, :password_hash, 'accountant', 'active')");
    $stmt->execute([
        'full_name' => $fullName,
        'email' => $email,
        'password_hash' => $hashedPassword
    ]);

    // Send a confirmation email (use an actual mail function or service here)
    $to = $email;
    $subject = 'Account Activation';
    $message = 'Click the link to activate your account: <activation_link>';
    mail($to, $subject, $message);

    $_SESSION['register_success'] = 'Registration successful. Please check your email for activation.';
    header("Location: index.php");
    exit();
}
?>
