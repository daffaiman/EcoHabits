import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  // Data Dummy untuk Tips
  final List<Map<String, dynamic>> _tips = const [
    {
      "title": "Matikan Lampu",
      "desc":
          "Matikan lampu saat meninggalkan ruangan untuk menghemat energi dan biaya listrik.",
      "icon": Icons.lightbulb_outline_rounded,
      "color": Colors.orange,
    },
    {
      "title": "Bawa Tas Belanja",
      "desc":
          "Kurangi penggunaan kantong plastik sekali pakai dengan membawa tote bag sendiri.",
      "icon": Icons.shopping_bag_outlined,
      "color": Colors.blue,
    },
    {
      "title": "Hemat Air",
      "desc":
          "Jangan biarkan keran air menyala saat menyikat gigi atau mencuci piring.",
      "icon": Icons.water_drop_outlined,
      "color": Colors.cyan,
    },
    {
      "title": "Daur Ulang Sampah",
      "desc":
          "Pisahkan sampah organik dan anorganik agar mudah didaur ulang kembali.",
      "icon": Icons.recycling_rounded,
      "color": Colors.green,
    },
    {
      "title": "Gunakan Transportasi Umum",
      "desc":
          "Kurangi jejak karbon kendaraan pribadi dengan menggunakan bus atau kereta.",
      "icon": Icons.directions_bus_outlined,
      "color": Colors.red,
    },
    {
      "title": "Tanam Pohon",
      "desc":
          "Menanam satu pohon di halaman rumah dapat membantu menyerap CO2.",
      "icon": Icons.park_outlined,
      "color": Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6), // Background hijau pastel muda
      appBar: AppBar(
        title: const Text(
          "Eco Tips",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green[900],
        automaticallyImplyLeading:
            false, // Hilangkan tombol back (karena ini Tab)
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _tips.length,
        itemBuilder: (context, index) {
          final tip = _tips[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ikon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: (tip['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(tip['icon'], color: tip['color'], size: 28),
                ),
                const SizedBox(width: 16),

                // Teks Judul & Deskripsi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tip['desc'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
