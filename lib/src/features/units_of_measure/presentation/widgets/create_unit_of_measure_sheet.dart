import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../imports/core_imports.dart';
import '../../domain/entities/unit_of_measure.dart';
import '../providers/create_unit_provider.dart';
import '../providers/unit_of_measure_form_provider.dart';

class CreateUnitOfMeasureSheet
    extends ConsumerStatefulWidget {
  const CreateUnitOfMeasureSheet({
    super.key,
    this.initialUnit,
  });

  final UnitOfMeasure? initialUnit;

  @override
  ConsumerState<
      CreateUnitOfMeasureSheet> createState() =>
      _CreateUnitOfMeasureSheetState();
}

class _CreateUnitOfMeasureSheetState
    extends ConsumerState<
        CreateUnitOfMeasureSheet> {
  final _formKey =
  GlobalKey<FormState>();

  late final TextEditingController
  _nameController;

  late final TextEditingController
  _abbreviationController;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.initialUnit?.name ?? '');

    _abbreviationController =
        TextEditingController(text: widget.initialUnit?.abbreviation ?? '');

    // Set initial values in provider without triggering listeners yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(unitOfMeasureFormProvider.notifier);
      notifier.setName(_nameController.text);
      notifier.setAbbreviation(_abbreviationController.text);
    });

    _nameController.addListener(() {
      ref
          .read(
        unitOfMeasureFormProvider
            .notifier,
      )
          .setName(
        _nameController.text,
      );
    });

    _abbreviationController
        .addListener(() {
      ref
          .read(
        unitOfMeasureFormProvider
            .notifier,
      )
          .setAbbreviation(
        _abbreviationController.text,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final form = ref.read(
      unitOfMeasureFormProvider,
    );

    if (widget.initialUnit != null) {
      await ref
          .read(createUnitProvider.notifier)
          .updateUnit(
        id: widget.initialUnit!.id,
        name: form.name.trim(),
        abbreviation: form.abbreviation
            .trim()
            .toLowerCase(),
      );
    } else {
      await ref
          .read(createUnitProvider.notifier)
          .create(
        name: form.name.trim(),
        abbreviation: form.abbreviation
            .trim()
            .toLowerCase(),
      );
    }
  } 
  @override
  Widget build(
      BuildContext context,
      ) {


    ref.listen(
      createUnitProvider,
          (previous, next) {
        next.whenOrNull(
          data: (_) {
            if (!mounted) return;

            ref
                .read(
              unitOfMeasureFormProvider.notifier,
            )
                .reset();

            Navigator.pop(context, true);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unit created successfully',
                ),
              ),
            );
          },
          error: (error, stack) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error.toString(),
                ),
              ),
            );
          },
        );
      },
    );
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final formState =
    ref.watch(unitOfMeasureFormProvider);

    final createState =
    ref.watch(createUnitProvider);

    final isLoading =
        createState.isLoading;

    return SafeArea(
      child: Padding(
        padding:
        EdgeInsets.only(
          left: 20,
          right: 20,
          top: 5,
          bottom:
          MediaQuery.of(context)
              .viewInsets
              .bottom +
              20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .onSurfaceVariant
                        .withValues(
                      alpha: 0.35,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      100,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ------------------------------------------
              // HEADER
              // ------------------------------------------

              Row(
                children: [



                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [

                        Text(
                          widget.initialUnit == null ? 'Create unit' : 'Update unit',
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        Text(
                          widget.initialUnit == null ? 'Add a new unit of measure' : 'Edit this unit of measure',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed:
                    formState.isLoading
                        ? null
                        : () {
                      Navigator.of(
                        context,
                      ).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),



              AppTextField(
                controller: _nameController,
                enabled: !formState.isLoading,
                textInputAction: TextInputAction.next,
                hint: 'e.g. Kilogram',
                label: 'Unit name',
                underlined: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a unit name';
                  }

                  if (value.trim().length < 2) {
                    return 'Unit name is too short';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 5),

              AppTextField(
                controller: _abbreviationController,
                enabled: !formState.isLoading,
                textInputAction: TextInputAction.done,
                hint: 'e.g. kg',
                label: 'Abbreviation',
                underlined: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an abbreviation';
                  }

                  if (value.trim().length > 10) {
                    return 'Maximum 10 characters';
                  }

                  return null;
                },
              ),


              if (formState
                  .errorMessage !=
                  null) ...[
                const SizedBox(
                  height: 16,
                ),

                Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .errorContainer,
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Row(
                    children: [

                      Icon(
                        Icons
                            .error_outline_rounded,
                        size: 20,
                        color: colorScheme
                            .onErrorContainer,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Expanded(
                        child: Text(
                          formState
                              .errorMessage!,
                          style: TextStyle(
                            color: colorScheme
                                .onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height: 24,
              ),

              // ------------------------------------------
              // SUBMIT
              // ------------------------------------------

              SizedBox(
                width:
                double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed:
                  formState.isLoading
                      ? null
                      : _submit,
                  child:
                  formState.isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    widget.initialUnit == null ? 'Create unit' : 'Update unit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
