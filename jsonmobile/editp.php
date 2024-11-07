<?php
// Koneksi ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");


if (!$conn) {
    die(json_encode(["pesan" => "Koneksi ke database gagal: " . mysqli_connect_error()]));
}

$id = mysqli_real_escape_string($conn, $_POST['id']);
$noiden = mysqli_real_escape_string($conn, $_POST['No_identitas']);
$nama = mysqli_real_escape_string($conn, $_POST['Nama']);
$kls = mysqli_real_escape_string($conn, $_POST['Kelas']);
$jrs = mysqli_real_escape_string($conn, $_POST['Jurusan']);

$query = "UPDATE peminjam SET No_identitas = '$noiden', Nama = '$nama', Kelas = '$kls', Jurusan = '$jrs' WHERE id = '$id'";
$data = mysqli_query($conn, $query);

if ($data) {
    echo json_encode(["pesan" => "sukses"]);
} else {
    echo json_encode(["pesan" => "gagal", "error" => mysqli_error($conn)]);
}

mysqli_close($conn);
?>
