<?php
$conn=mysqli_connect("localhost","root","","peminjamanbarang");
$id = $_POST['id'];
$kode = $_POST['Kode_barang'];
$nama = $_POST['nama_barang'];
$jml = $_POST['Jumlah_barang'];
$data = mysqli_query($conn, "UPDATE barang SET Kode_barang = '$kode', nama_barang = '$nama' , Jumlah_barang = '$jml' WHERE id = '$id'");
if ($data) {
    echo json_encode([
        "pesan" => "sukses"]);
}else {
    echo json_encode([
        "pesan" => "gagal"]);
}
?>