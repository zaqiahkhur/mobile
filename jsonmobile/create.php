<?php
$conn=mysqli_connect("localhost","root","","peminjamanbarang");
$kodebarang = $_POST['Kode_barang'];
$namabarang = $_POST['nama_barang'];
$jumlahbarang = $_POST['Jumlah_barang'];
$data = mysqli_query($conn, "insert into barang set Kode_barang='$kodebarang',nama_barang='$namabarang',Jumlah_barang='$jumlahbarang'");
if ($data) {
    echo json_encode([
        "pesan" => "sukses"]);
}else {
    echo json_encode([
        "pesan" => "gagal"]);
}
?>