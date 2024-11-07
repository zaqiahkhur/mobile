<?php
// Koneksi ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

// Memeriksa metode request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Mengambil data dari POST
    $kode_pinjam = $_POST['Kode_pinjam'];
    $kode_barang = $_POST['kode_barang'];
    $no_identitas = $_POST['no_identitas'];
    $jumlah_barang = $_POST['Jumlah_barang'];
    $tanggal_pinjam = $_POST['tanggal_pinjam'];
    $tanggal_kembali = $_POST['tanggal_kembali'];
    $status = $_POST['status'];
    $keperluan = $_POST['keperluan'];

    // Query SQL untuk menyimpan data peminjaman
    $sql = "INSERT INTO peminjaman (Kode_pinjam, kode_barang, no_identitas, Jumlah_barang, tanggal_pinjam, tanggal_kembali, status, keperluan) 
            VALUES ('$kode_pinjam', '$kode_barang', '$no_identitas', '$jumlah_barang', NOW(), '$tanggal_kembali', '$status', '$keperluan')";

    // Eksekusi query dan cek hasil
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["success" => true, "message" => "Peminjaman berhasil disimpan"]);
    } else {
        echo json_encode(["success" => false, "message" => "Peminjaman gagal disimpan: " . mysqli_error($conn)]);
    }

    // Tutup koneksi
    mysqli_close($conn);
} else {
    echo json_encode(["success" => false, "message" => "Metode request tidak valid"]);
}
?>
