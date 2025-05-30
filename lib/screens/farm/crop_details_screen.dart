import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/providers/ai_provider.dart';
import 'package:farmer_connect/models/crop_detail.dart';

class CropDetailsScreen extends StatefulWidget {
  const CropDetailsScreen({Key? key}) : super(key: key);

  @override
  _CropDetailsScreenState createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropController = TextEditingController();
  final _locationController = TextEditingController();
  CropDetails? _cropDetails;

  @override
  void dispose() {
    _cropController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCropDetails() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final aiProvider = Provider.of<AIProvider>(context, listen: false);
      final details = await aiProvider.getCropDetails(
        _cropController.text,
        _locationController.text,
      );

      setState(() {
        _cropDetails = CropDetails(
          cropName: details['cropName'] as String,
          imageUrl: '', // You might want to add image URL handling
          description: details['growingConditions'] as String,
          season: details['plantingSeason'] as String,
          tips: details['pestsAndDiseases'] as String,
          location: _locationController.text,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cropController,
                    decoration: const InputDecoration(
                      labelText: 'Crop Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter crop name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter location' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _getCropDetails,
                    child: const Text('Get Crop Details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cropDetails != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _cropDetails!.cropName,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Location: ${_cropDetails!.location}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Description:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(_cropDetails!.description),
                              const SizedBox(height: 16),
                              Text(
                                'Season: ${_cropDetails!.season}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tips:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(_cropDetails!.tips),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 