import 'package:flutter/material.dart';

class DocumentsPage extends StatelessWidget {
  final List<Map<String, String>> documents = [
    {'title': "Carte d'identité nationale", 'image': ''},
    {'title': "Permis de conduite", 'image': ''},
    {'title': "Carte grise véhicule", 'image': ''},
    {'title': "Contrat signé", 'image': 'assets/contrat.png'}, // example image
    {'title': "Attestation", 'image': ''},
    {'title': "Autre", 'image': 'assets/autre.png'}, // example image
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Complétez les documents",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.description_outlined,
                  size: 40,
                  color: Colors.grey,
                ),
                title: Text(doc['title']!),
                trailing: IconButton(
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.green),
                  onPressed: () {
                    // Here you can add camera functionality
                    print("Open camera for ${doc['title']}");
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
