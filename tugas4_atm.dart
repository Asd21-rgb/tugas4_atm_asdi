// ====================================================================
// 1. CLASS NASABAH
// ====================================================================
class Nasabah {
  String nama;
  String noRekening;
  double _saldo; // Atribut privat ditandai dengan tanda undscore (_)

  // Constructor Bernama (Named Constructor)
  Nasabah.buatAkun({
    required this.nama,
    required this.noRekening,
    required double saldoAwal,
  }) : _saldo = (saldoAwal >= 0) ? saldoAwal : 0 {
    // Memastikan saldo awal tidak bernilai negatif saat akun dibuat
  }

  // Getter untuk mengambil data saldo privat
  double get saldo => _saldo;

  // Setter untuk mengubah nilai saldo privat disertai validasi
  set saldo(double jumlahBaru) {
    if (jumlahBaru >= 0) {
      _saldo = jumlahBaru;
    } else {
      throw Exception("Gagal mengupdate saldo: Nilai saldo tidak boleh negatif!");
    }
  }
}

// ====================================================================
// 2. CLASS ATM
// ====================================================================
class ATM {
  // Method untuk menyetor uang
  void setor(Nasabah nasabah, double jumlah) {
    if (jumlah <= 0) {
      throw Exception("Gagal Setor: Jumlah setoran harus lebih besar dari Rp 0!");
    }
    nasabah.saldo += jumlah; // Menggunakan setter nasabah
    print("✅ Berhasil: Setor tunai ke rekening [${nasabah.noRekening}] sebesar Rp ${jumlah.toStringAsFixed(0)}");
  }

  // Method untuk menarik uang
  void tarik(Nasabah nasabah, double jumlah) {
    if (jumlah <= 0) {
      throw Exception("Gagal Tarik: Jumlah penarikan harus lebih besar dari Rp 0!");
    }
    if (nasabah.saldo < jumlah) {
      // Melempar exception jika saldo di tabungan tidak mencukupi (Soal 2)
      throw Exception("❌ Transaksi Ditolak: Saldo rekening [${nasabah.noRekening}] tidak mencukupi!");
    }
    nasabah.saldo -= jumlah; // Menggunakan setter nasabah
    print("✅ Berhasil: Tarik tunai dari rekening [${nasabah.noRekening}] sebesar Rp ${jumlah.toStringAsFixed(0)}");
  }

  // 5. Method Asinkronus untuk simulasi cek saldo via internet/server online
  Future<double> cekSaldoOnline(Nasabah nasabah) {
    // Menunda eksekusi selama 2 detik menggunakan Future.delayed (Soal 5)
    return Future.delayed(Duration(seconds: 2), () {
      return nasabah.saldo;
    });
  }
}

// ====================================================================
// PROGRAM UTAMA (MAIN)
// ====================================================================
void main() async {
  print("====================================================");
  print("          SIMULASI SISTEM MESIN ATM BANK            ");
  print("====================================================\n");

  // 4. Menyimpan minimal 3 nasabah dalam List<Nasabah>
  List<Nasabah> daftarNasabah = [
    Nasabah.buatAkun(nama: "Muhammad Asdiani", noRekening: "2410020096", saldoAwal: 500000),
    Nasabah.buatAkun(nama: "Budi Setiawan", noRekening: "1102003044", saldoAwal: 50000),
    Nasabah.buatAkun(nama: "Citra Lestari", noRekening: "1102003055", saldoAwal: 1500000),
  ];

  // Membuat objek mesin ATM
  ATM mesinATM = ATM();

  // -----------------------------------------------------------------
  // UJI COBA 1: Transaksi Normal (Setor & Tarik)
  // -----------------------------------------------------------------
  print("--- [UJI COBA 1: TRANSAKSI NORMAL] ---");
  Nasabah nasabah1 = daftarNasabah[0]; // Akun Anda sendiri
  print("Nasabah aktif: ${nasabah1.nama} (${nasabah1.noRekening})");
  print("Saldo Awal   : Rp ${nasabah1.saldo.toStringAsFixed(0)}");
  
  mesinATM.setor(nasabah1, 200000); // Setor 200 ribu
  print("Saldo Saat Ini: Rp ${nasabah1.saldo.toStringAsFixed(0)}");
  
  mesinATM.tarik(nasabah1, 150000); // Tarik 150 ribu
  print("Saldo Akhir  : Rp ${nasabah1.saldo.toStringAsFixed(0)}\n");

  // -----------------------------------------------------------------
  // UJI COBA 2: Try-Catch Menangkap Error Penarikan Berlebih (Soal 3)
  // -----------------------------------------------------------------
  print("--- [UJI COBA 2: TRY-CATCH ERROR SALDO KURANG] ---");
  Nasabah nasabah2 = daftarNasabah[1]; // Budi (Saldo 50 ribu)
  print("Nasabah aktif: ${nasabah2.nama} (${nasabah2.noRekening})");
  print("Saldo Budi   : Rp ${nasabah2.saldo.toStringAsFixed(0)}");

  try {
    print("Mencoba menarik uang sebesar Rp 100.000...");
    mesinATM.tarik(nasabah2, 100000); // Penarikan berlebih (50rb - 100rb)
  } catch (error) {
    // Menangkap pesan exception secara aman agar aplikasi tidak mati mendadak
    print("Pesan Tangkapan ATM System -> $error");
  }
  print("Status: Transaksi selesai diproses keamanan ATM.\n");

  // -----------------------------------------------------------------
  // UJI COBA 3: Panggilan Asinkronus dengan Await (Soal 6)
  // -----------------------------------------------------------------
  print("--- [UJI COBA 3: CEK SALDO ONLINE VIA SERVER] ---");
  Nasabah nasabah3 = daftarNasabah[2]; // Citra
  print("Menghubungkan ke server Bank cloud untuk akun ${nasabah3.nama}...");
  print("(Mohon tunggu 2 detik...)");
  
  // Menggunakan kata kunci 'await' untuk menanti respon server
  double saldoServer = await mesinATM.cekSaldoOnline(nasabah3);
  
  print("📡 Data Server Sinkron!");
  print("Saldo Nasabah ${nasabah3.nama} (Online): Rp ${saldoServer.toStringAsFixed(0)}");
  print("====================================================");
}