<?php
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

if (isset($_POST['Kode_pinjam'])) {
    $Kode_pinjam = $_POST['Kode_pinjam'];

    // Update status menjadi 'kembali'
    $query = "UPDATE peminjaman SET status = 'kembali' WHERE Kode_pinjam = '$Kode_pinjam'";
    if (mysqli_query($conn, $query)) {
        echo json_encode(["success" => true, "message" => "Status berhasil diperbarui."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal memperbarui status."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Kode_pinjam tidak ditemukan."]);
}
?>
