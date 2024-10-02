import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

class MeuPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200], // Fundo cinza claro
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 64, // Tamanho 128x128
                      backgroundImage:
                          AssetImage('assets/user.jfif'), // Imagem de exemplo
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Andrea Piacquadio',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Profissão',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                buildTextField('Nome'),
                buildTextField('Email'),
                buildTextField('Data de nascimento'),
                Text(
                  'Gênero',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text('Feminino'),
                        value: 'feminino',
                        groupValue: 'gênero',
                        onChanged: (value) {},
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('Masculino'),
                        value: 'masculino',
                        groupValue: 'gênero',
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                buildTextField('Telefone'),
                buildTextField('Localização'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Insira $label',
            ),
          ),
        ],
      ),
    );
  }
}
