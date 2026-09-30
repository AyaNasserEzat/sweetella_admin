import 'package:flutter_test/flutter_test.dart';
import 'package:sweetella_admin/features/products/data/models/product_model.dart';
import 'package:sweetella_admin/features/products/domain/entities/product.dart';
import 'package:sweetella_admin/features/products/domain/entities/product_category.dart';
import 'package:sweetella_admin/features/products/domain/errors/product_failure.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';
import 'package:sweetella_admin/features/products/domain/usecases/product_use_cases.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_state.dart';

void main() {
  group('Product model', () {
    test(
      'serializes the customer Firestore field names and nested options',
      () {
        final model = ProductModel.fromEntity(_product());
        final json = model.toFirestore();

        expect(json.keys.toSet(), {
          'id',
          'categoryId',
          'name',
          'description',
          'price',
          'imageUrl',
          'salePrice',
          'attributes',
        });
        expect(json['price'], 125);
        expect(json['salePrice'], 100);
        expect(json['attributes'], [
          {
            'title': 'Size',
            'options': [
              {'value': 'Small', 'price_modifier': 0.0, 'stock': 4},
            ],
          },
        ]);
      },
    );

    test('products without stock options are treated as available', () {
      expect(_product(attributes: const []).isAvailable, isTrue);
      expect(_product().isAvailable, isTrue);
      expect(
        _product(
          attributes: const [
            ProductAttribute(
              title: 'Size',
              options: [
                ProductOption(value: 'Small', priceModifier: 0, stock: 0),
              ],
            ),
          ],
        ).isAvailable,
        isFalse,
      );
    });
  });

  group('ProductCubit', () {
    late _FakeProductRepository repository;
    late ProductCubit cubit;

    ProductCubit createCubit() {
      return ProductCubit(
        getProducts: GetProducts(repository),
        getCategories: GetProductCategories(repository),
        addProduct: AddProduct(repository),
        updateProduct: UpdateProduct(repository),
        deleteProduct: DeleteProduct(repository),
      );
    }

    setUp(() {
      repository = _FakeProductRepository(products: [_product()]);
      cubit = createCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('load emits loading followed by success', () async {
      final states = <ProductState>[];
      final subscription = cubit.stream.listen(states.add);
      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([isA<ProductLoading>(), isA<ProductLoadSuccess>()]),
      );

      await cubit.loadProducts();
      await emitted;
      expect(states, hasLength(2));
      expect((states.last as ProductLoadSuccess).products, hasLength(1));
      await subscription.cancel();
    });

    test('load reports an error', () async {
      repository.failure = const ProductFailure(
        ProductFailureKind.permissionDenied,
      );

      await cubit.loadProducts();

      expect(cubit.state, isA<ProductLoadError>());
      expect(
        (cubit.state as ProductLoadError).failure,
        ProductFailureKind.permissionDenied,
      );
    });

    test(
      'load emits the explicit empty state when Firestore has no products',
      () async {
        repository.products.clear();

        await cubit.loadProducts();

        expect(cubit.state, isA<ProductEmpty>());
        expect((cubit.state as ProductEmpty).products, isEmpty);
      },
    );

    test('add succeeds and reports failures', () async {
      await cubit.loadProducts();
      final added = _product(id: 'created-id', name: 'New product');

      expect(await cubit.add(added), isTrue);
      expect(cubit.state, isA<ProductAddSuccess>());
      expect((cubit.state as ProductAddSuccess).products, hasLength(2));

      repository.failure = const ProductFailure(ProductFailureKind.unknown);
      expect(await cubit.add(added), isFalse);
      expect(cubit.state, isA<ProductAddError>());
      expect((cubit.state as ProductAddError).products, hasLength(2));
    });

    test('update succeeds without duplicating and reports failures', () async {
      await cubit.loadProducts();
      final updated = _product(id: 'product-id', name: 'Updated product');

      expect(await cubit.update(updated), isTrue);
      expect(cubit.state, isA<ProductUpdateSuccess>());
      final updatedProducts = (cubit.state as ProductUpdateSuccess).products;
      expect(updatedProducts, hasLength(1));
      expect(updatedProducts.single.name, 'Updated product');

      repository.failure = const ProductFailure(ProductFailureKind.unknown);
      expect(await cubit.update(updated), isFalse);
      expect(cubit.state, isA<ProductUpdateError>());
      expect((cubit.state as ProductUpdateError).products, hasLength(1));
    });

    test('delete succeeds and reports failures', () async {
      await cubit.loadProducts();

      expect(await cubit.delete('product-id'), isTrue);
      expect(cubit.state, isA<ProductDeleteSuccess>());
      expect((cubit.state as ProductDeleteSuccess).products, isEmpty);

      repository.products.add(_product());
      await cubit.loadProducts();
      repository.failure = const ProductFailure(ProductFailureKind.unknown);
      expect(await cubit.delete('product-id'), isFalse);
      expect(cubit.state, isA<ProductDeleteError>());
      expect((cubit.state as ProductDeleteError).products, hasLength(1));
    });
  });
}

Product _product({
  String id = 'product-id',
  String name = 'Test product',
  List<ProductAttribute>? attributes,
}) {
  return Product(
    id: id,
    name: name,
    categoryId: 'category-id',
    description: 'Product description',
    price: 125,
    salePrice: 100,
    imageUrl: 'https://example.com/product.jpg',
    attributes:
        attributes ??
        const [
          ProductAttribute(
            title: 'Size',
            options: [
              ProductOption(value: 'Small', priceModifier: 0, stock: 4),
            ],
          ),
        ],
  );
}

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository({required this.products});

  final List<Product> products;
  ProductFailure? failure;

  void _throwIfFailed() {
    final failure = this.failure;
    if (failure != null) throw failure;
  }

  @override
  Future<List<Product>> getProducts() async {
    _throwIfFailed();
    return List.of(products);
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    _throwIfFailed();
    return const [
      ProductCategory(id: 'category-id', name: 'Category', imageUrl: ''),
    ];
  }

  @override
  Future<Product> addProduct(Product product) async {
    _throwIfFailed();
    final savedProduct = product.id.isEmpty
        ? product.copyWith(id: 'created-id')
        : product;
    products.add(savedProduct);
    return savedProduct;
  }

  @override
  Future<void> updateProduct(Product product) async {
    _throwIfFailed();
    final index = products.indexWhere((item) => item.id == product.id);
    if (index >= 0) products[index] = product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _throwIfFailed();
    products.removeWhere((product) => product.id == id);
  }
}
