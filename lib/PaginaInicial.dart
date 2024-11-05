import 'package:flutter/material.dart';

class PaginaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        child: const Center( 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza a Row horizontalmente
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centraliza a Column verticalmente
                crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente dentro da Column
                children: [
                  Icon(
                    Icons.business_center_rounded, 
                    size: 200, 
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jobber',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
