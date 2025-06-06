import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LlmService {
  final String _openAiUrl = 'https://api.openai.com/v1/completions'; 
  final String _openAiModel = 'gpt-3.5-turbo'; 

  Future<List<String>> generateStartupNames(String description, {int count = 5}) async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];

      if (apiKey == null) {
        throw Exception('API key not found. Please check your .env file.');
      }

      if (description.trim().isEmpty) {
        return _getMockNames(count);
      }

      final prompt = "Gere $count nomes criativos, inovadores e memoráveis para uma startup que: $description. Forneça apenas os nomes, sem explicações adicionais.";

      final response = await http.post(
        Uri.parse(_openAiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _openAiModel,
          'prompt': prompt,
          'max_tokens': 100,
          'temperature': 0.7,
          'top_p': 0.95,
          'n': count,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data != null && data.containsKey('choices') && data['choices'].isNotEmpty) {
            final choices = data['choices'];
            final List<String> names = [];
            for (var choice in choices) {
              final text = choice['text'];
              final extractedNames = _extractNames(text, count);
              names.addAll(extractedNames);
              if (names.length >= count) break;
            }
            return names.take(count).toList();
          }
          print('Resposta da API em formato inesperado: ${response.body}');
          return _getMockNames(count);
        } catch (e) {
          print('Erro ao processar resposta da API: $e');
          return _getMockNames(count);
        }
      } else {
        print('Erro na API (${response.statusCode}): ${response.body}');
        return _getMockNames(count);
      }
    } catch (e) {
      print('Erro ao chamar API: $e');
      return _getMockNames(count);
    }
  }

  List<String> _extractNames(String text, int count) {
    final regex = RegExp(r'\d+\.\s*([^\n\d]+)'); 
    final matches = regex.allMatches(text);

    final names = <String>[];
    for (var match in matches) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleanName = _cleanName(name);
        if (cleanName.isNotEmpty) {
          names.add(cleanName);
          if (names.length >= count) break;
        }
      }
    }

    if (names.isEmpty) {
      final lines = text.split('\n');
      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty && trimmed.length > 3 && !trimmed.contains(':') && !trimmed.toLowerCase().contains('nome')) {
          names.add(trimmed);
          if (names.length >= count) break;
        }
      }
    }

    if (names.length < count) {
      final fallbackNames = _getMockNames(count - names.length);
      names.addAll(fallbackNames);
    }

    return names;
  }

  String _cleanName(String name) {
    final regex = RegExp(r'[^a-zA-Z0-9\s]');
    return name.replaceAll(regex, '').trim();
  }

  List<String> _getMockNames(int count) {
    final List<String> mockPrefixes = [
      'Tech', 'Smart', 'Inova', 'Future', 'Next', 'Bright', 'Eco', 'Digi', 'Cyber', 'Meta',
      'Ágil', 'Nexo', 'Viva', 'Flux', 'Evo', 'Neuro', 'Quantum', 'Omni', 'Hyper', 'Zenith',
      'Verso', 'Orbi', 'Lumina', 'Pulse', 'Nova', 'Atom', 'Fusion', 'Visão', 'Conecta', 'Impulso'
    ];

    final List<String> mockSuffixes = [
      'Hub', 'Labs', 'AI', 'Solutions', 'Connect', 'Link', 'Wave', 'Sync', 'Mind', 'Pulse',
      'Tech', 'Go', 'Now', 'Fy', 'Ware', 'Base', 'Cloud', 'Data', 'Code', 'App',
      'Bit', 'Net', 'Mente', 'Flow', 'Spark', 'Boost', 'Grow', 'Nexus', 'Sphere', 'Verse'
    ];

    final random = Random();
    final List<String> names = [];

    for (int i = 0; i < count; i++) {
      final prefixIndex = random.nextInt(mockPrefixes.length);
      final suffixIndex = random.nextInt(mockSuffixes.length);
      names.add('${mockPrefixes[prefixIndex]}${mockSuffixes[suffixIndex]}');
    }

    return names;
  }
}
