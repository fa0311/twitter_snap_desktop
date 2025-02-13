import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_snap_desktop/component/future/button.dart';
import 'package:twitter_snap_desktop/component/layout.dart';
import 'package:twitter_snap_desktop/controller/twitter_snap_controller.dart';
import 'package:twitter_snap_desktop/output_view.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    Future<void> onRemoveTempPressed() async {
      await getApplicationCacheDirectory().then((dir) => dir.delete(recursive: true));
    }

    return LayoutWidget(
      child: Form(
        key: formKey,
        child: Wrap(
          runSpacing: 20,
          children: [
            TextFormField(
              controller: text,
              decoration: const InputDecoration(labelText: 'Text'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: FutureButton(
                type: ButtonType.elevatedButton,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    unawaited(ref.read(twitterSnapNotifierProvider.notifier).exec(text.text));
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const OutputViewPage(),
                      ),
                    );
                  }
                },
                child: const Text('Snap'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FutureButton(
                type: ButtonType.elevatedButton,
                onPressed: onRemoveTempPressed,
                child: const Text('Remove Temp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
