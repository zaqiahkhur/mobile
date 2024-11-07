<?php   
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

$uname = $_POST['username'];
$upass = $_POST['password'];

$hasil = mysqli_query($conn, "SELECT * FROM admin WHERE username='$uname' AND password='$upass'");
if (mysqli_num_rows($hasil) > 0) {
    $user = mysqli_fetch_assoc($hasil);

    echo json_encode([
        'success' => true,
        'message' => 'Login berhasil',
        'username' => $user['username'],
        'role' => $user['role']
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Username atau password salah'
    ]);
}
?>
