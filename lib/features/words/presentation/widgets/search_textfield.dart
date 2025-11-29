import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_textfield.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({super.key});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      hintText: '${context.translate.searchPlaceholder} ...',
      textEditingController: _searchController,
      onChanged: (query) {
        context.read<TotalWordsBloc>().add(SearchWordsEvent(query));
      },
      onClearPressed: () {
        context.read<TotalWordsBloc>().add(SearchWordsEvent(''));
      },
    );
  }
}
