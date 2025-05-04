import 'package:flutter/material.dart';
import '../models/startup_name.dart';
import '../services/llm_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final LlmService _llmService = LlmService();
  final List<StartupName> _generatedNames = [];
  final List<StartupName> _favoriteNames = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateNames() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma descrição do negócio')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedNames.clear();
    });

    try {
      final names = await _llmService.generateStartupNames(description);
      setState(() {
        _generatedNames.addAll(
          names.map((name) => StartupName(name: name)),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar nomes: ${e.toString()}')),
      );
    }
  }

  void _toggleFavorite(StartupName name) {
    setState(() {
      final index = _generatedNames.indexWhere((n) => n.name == name.name);
      if (index != -1) {
        final updatedName = _generatedNames[index].copyWith(
          isFavorite: !_generatedNames[index].isFavorite,
        );
        _generatedNames[index] = updatedName;

        if (updatedName.isFavorite) {
          _favoriteNames.add(updatedName);
        } else {
          _favoriteNames.removeWhere((n) => n.name == updatedName.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerador de Nomes para Startups'),
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Gerador'),
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildGeneratorTab(),
            _buildFavoritesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho informativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚀 Gerador de Nomes para Startups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                SizedBox(height: 8),
                Text(
                  'Descreva seu negócio ou ideia de startup e nosso sistema de IA irá gerar nomes criativos e memoráveis para sua empresa.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Descreva seu negócio:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Ex: Um app de entrega de comida saudável',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.lightbulb_outline, color: Colors.purple),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _generateNames,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome),
                      SizedBox(width: 8),
                      Text(
                        'GERAR NOMES',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          if (_generatedNames.isNotEmpty) ...[            
            Row(
              children: [
                const Icon(Icons.list_alt, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Sugestões de nomes:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${_generatedNames.length} nomes gerados',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _generatedNames.length,
                itemBuilder: (context, index) {
                  final name = _generatedNames[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        name.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          name.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: name.isFavorite ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () => _toggleFavorite(name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (!_isLoading) ...[            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'Descreva seu negócio e clique em "GERAR NOMES" para obter sugestões',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho da aba de favoritos
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '❤️ Seus Nomes Favoritos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  'Aqui você encontra todos os nomes que marcou como favoritos. Eles ficarão salvos para você consultar depois.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _favoriteNames.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Você ainda não tem nomes favoritos',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Marque nomes como favoritos na aba Gerador',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _favoriteNames.length,
                  itemBuilder: (context, index) {
                    final name = _favoriteNames[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          name.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                          onPressed: () => _toggleFavorite(name),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}