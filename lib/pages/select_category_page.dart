import 'package:flutter/material.dart';
import 'package:gym_log/repositories/category_repository.dart';
import 'package:gym_log/widgets/empty_message.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Importar lista de exercícios'),
            Flexible(
              child: Text(
                maxLines: 2,
                'A lista de exercícios atual não será substituída, será apenas concatenada com a lista a ser importada.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: CategoryRepository().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          List<String> categories = snapshot.data!;

          if (categories.isEmpty) {
            return const EmptyMessage(
              'Não existem categorias para serem selecionadas.\nCrie uma no Menu Principal -> ( + )',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 70),
            physics: const ClampingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) {
              String category = categories[index];

              return Stack(
                children: [
                  RadioListTile(
                    title: Text(category),
                    value: category,
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
