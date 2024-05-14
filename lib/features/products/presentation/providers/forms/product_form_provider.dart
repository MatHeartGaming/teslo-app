import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  final createUpadateCallback =
      ref.watch(productsProvider.notifier).createorUpdateProduct;
  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpadateCallback,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          sizes: product.sizes,
          gender: product.gender,
          inStock: Stock.dirty(product.stock),
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        ));

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid:
          Formz.validate([state.title, state.slug, state.inStock, state.price]),
    );
  }

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;

    final productLike = {
      "id": (state.id == 'new') ? null : state.id,
      "title": state.title.value,
      "price": state.price.value,
      "description": state.description,
      "slug": state.slug.value,
      "stock": state.inStock.value,
      "sizes": state.sizes,
      "gender": state.gender,
      "tags": state.tags.split(', '),
      "images": state.images
          .map((img) =>
              img.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void onTitleChanged(String value) {
    final newTitle = Title.dirty(value);
    state = state.copyWith(
      title: newTitle,
      isFormValid: Formz.validate([
        newTitle,
        state.slug,
        state.price,
        state.inStock,
      ]),
    );
  }

  void onSlugChanged(String value) {
    final newSlug = Slug.dirty(value);
    state = state.copyWith(
      slug: newSlug,
      isFormValid: Formz.validate([
        newSlug,
        state.title,
        state.price,
        state.inStock,
      ]),
    );
  }

  void onPriceChanged(double value) {
    final newPrice = Price.dirty(value);
    state = state.copyWith(
      price: newPrice,
      isFormValid: Formz.validate([
        newPrice,
        state.slug,
        state.title,
        state.inStock,
      ]),
    );
  }

  void onStockChanged(int value) {
    final newStock = Stock.dirty(value);
    state = state.copyWith(
      inStock: newStock,
      isFormValid: Formz.validate([
        newStock,
        state.slug,
        state.title,
        state.price,
      ]),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  void updateProductImage(String path) {
    state = state.copyWith(images: [...state.images, path]);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gender = 'man',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
