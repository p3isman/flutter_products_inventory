import 'package:flutter/material.dart';

import 'package:products/bloc/provider.dart';
import 'package:products/models/product_model.dart';
import 'package:products/pages/product_page.dart';
import 'package:products/providers/products_provider.dart';

final _productsProvider = new ProductsProvider();

class HomePage extends StatefulWidget {
  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        child: _Body(_updateHome),
        onRefresh: _updateHome,
      ),
      floatingActionButton: _AddProductButton(_updateHome),
    );
  }

  // Called when returning to the home page and when refreshing
  Future<void> _updateHome() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {});
  }
}

class _AddProductButton extends StatelessWidget {
  _AddProductButton(this.updateHome);

  final Function updateHome;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      // .then is called after popping off the route
      onPressed: () => Navigator.pushNamed(context, ProductPage.routeName)
          .then((value) => updateHome()),
    );
  }
}

class _Body extends StatelessWidget {
  _Body(this.updateHome);

  final Function updateHome;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productsProvider.loadProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) => _Item(products[i], updateHome),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _Item extends StatelessWidget {
  _Item(this.product, this.updateHome);

  final Product product;
  final Function updateHome;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) => _productsProvider.deleteProduct(product.id!),
      child: Card(
        child: Column(
          children: [
            (product.pictureUrl == null)
                ? Image.asset('assets/no-image.png')
                : FadeInImage(
                    placeholder: Image.asset('assets/jar-loading.gif').image,
                    image: NetworkImage(product.pictureUrl!),
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.price}'),
              subtitle: Text('${product.id}'),
              onTap: () => Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: product)
                  .then((value) => updateHome()),
            ),
          ],
        ),
      ),
    );
  }
}
