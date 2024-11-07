<?php

// Koneksi ke database
$koneksi = mysqli_connect("localhost", "root", "", "peminjamanbarang");

if (!$koneksi) {
    echo json_encode([
        "success" => false,
        "message" => "Gagal terhubung ke database"
    ]);
    exit;
}

// Mengambil data dari POST request
$xkodepinjam = $_POST['kodepinjam'] ?? '';
$xkodebarang = $_POST['kodebarang'] ?? '';
$xnoiden = $_POST['noiden'] ?? '';
$xjmlbrg = intval($_POST['jml'] ?? 0);
$xtglkembali = $_POST['tglkembali'] ?? '';
$xstatus = $_POST['status'] ?? '';
$xkeperluan = $_POST['keperluan'] ?? '';

// Validasi apakah data lengkap
if (empty($xkodepinjam) || empty($xkodebarang) || empty($xnoiden) || $xjmlbrg <= 0 || empty($xtglkembali) || empty($xstatus) || empty($xkeperluan)) {
    echo json_encode([
        "success" => false,
        "message" => "Data tidak lengkap"
    ]);
    exit;
}

// Cek jumlah stok barang yang tersedia
$queryStok = "SELECT Jumlah_barang FROM barang WHERE kode_barang = '$xkodebarang'";
$resultStok = mysqli_query($koneksi, $queryStok);

if ($resultStok && mysqli_num_rows($resultStok) > 0) {
    $dataStok = mysqli_fetch_assoc($resultStok);
    $stokTersedia = intval($dataStok['Jumlah_barang']);

    // Jika jumlah barang yang dipinjam lebih besar dari stok yang tersedia
    if ($xjmlbrg > $stokTersedia) {
        echo json_encode([
            "success" => false,
            "message" => "Jumlah barang yang dipinjam melebihi jumlah stok yang tersedia"
        ]);
    } else {
        // Query untuk menyimpan data ke tabel peminjaman
        $sql = "INSERT INTO peminjaman (Kode_pinjam, kode_barang, no_identitas, Jumlah_barang, tanggal_pinjam, tanggal_kembali, status, keperluan) 
                VALUES ('$xkodepinjam', '$xkodebarang', '$xnoiden', '$xjmlbrg', NOW(), '$xtglkembali', '$xstatus', '$xkeperluan')";
        
        $save = mysqli_query($koneksi, $sql);

        if ($save) {
            echo json_encode([
                "success" => true,
                "message" => "Peminjaman berhasil disimpan"
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Terjadi kesalahan saat menyimpan data: " . mysqli_error($koneksi)
            ]);
        }
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Barang tidak ditemukan atau terjadi kesalahan: " . mysqli_error($koneksi)
    ]);
}

// Tutup koneksi
mysqli_close($koneksi);
?>
