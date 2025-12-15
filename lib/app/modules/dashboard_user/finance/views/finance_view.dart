import 'package:flutter/material.dart';

class FinanceView extends StatelessWidget {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EcoCampus",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Berita Finance",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            itemCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return financeCard();
            },
          ),
        ],
      ),
    );
  }

  Widget financeCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              "https://i.ibb.co/6HkG1v1/finance.jpg",
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xffCDEEFF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: const Text(
              "Berita Keuangan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
