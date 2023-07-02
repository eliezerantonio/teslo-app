import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../../../config/constannts/environment.dart';
import '../../../../../features/shared/shared.dart';
import '../../../domain/entities/product_entity.dart';

final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState,ProductEntity>((ref, product) {
  return ProductFormNotifier(product: product,);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required ProductEntity product})
      : super(
          ProductFormState(
            id: product.id,
            title: Title.dirty(product.title),
            stock: Stock.dirty(product.stock),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            sizes: product.sizes,
            gender: product.gender,
            description: product.description,
            tags: product.tags.join(','),
            images: product.images,
          ),
        );

  Future<bool> onFormSubmit() async {
    _touchEverything();

    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final proudctLike = {
      {
        "id": state.id,
        "title": state.title.value,
        "price": state.price.value,
        "description": state.description,
        "slug": state.slug,
        "stock": state.stock.value,
        "sizes": state.sizes,
        "gender": state.gender,
        "tags": state.tags.split(','),
        "images": state.images
            .map(
              (image) =>
                  image.replaceAll('${Environment.apiUrl}/files/product/', ''),
            )
            .toList()
      }
    };

    return true;
  }

  void _touchEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.stock.value),
    ]));
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ],
      ),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.stock.value),
        ],
      ),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.stock.value),
        ],
      ),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      stock: Stock.dirty(value),
      isFormValid: Formz.validate(
        [
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ],
      ),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Stock stock;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.stock = const Stock.dirty(0),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0.0),
    this.sizes = const [],
    this.gender = 'men',
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Stock? stock,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        stock: stock ?? this.stock,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
