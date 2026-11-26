
import 'package:flutter/material.dart';

void main() {
  runApp(const PapelariaApp());
}

// Modelo que representa um produto
class Produto {
  final String produto;
  final String marca;
  final String categoria;

  const Produto({
    required this.produto,
    required this.marca,
    required this.categoria,
  });
}

// Aplicativo principal
class PapelariaApp extends StatelessWidget {
  const PapelariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papelaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const ListaProdutosPage(),
    );
  }
}

// Tela de listagem
class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({super.key});

  @override
  State<ListaProdutosPage> createState() =>
      _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {

  // Lista armazenada em memória
  final List<Produto> _produtos = [
    const Produto(
      produto: 'Caderno',
      marca: 'Tilibra',
      categoria: 'Escolar',
    ),
  ];

  // Abre o formulário para cadastrar ou editar
  Future<void> _abrirFormulario({int? indice}) async {

    Produto? produtoAtual;

    if (indice != null) {
      produtoAtual = _produtos[indice];
    }

    final Produto? resultado =
        await Navigator.of(context).push<Produto>(
      MaterialPageRoute(
        builder: (context) {
          return FormularioProdutoPage(
            produto: produtoAtual,
          );
        },
      ),
    );

    // Atualiza a lista depois de salvar
    if (resultado != null && mounted) {
      setState(() {
        if (indice == null) {
          // Cadastro de um novo produto
          _produtos.add(resultado);
        } else {
          // Edição do produto existente
          _produtos[indice] = resultado;
        }
      });
    }
  }

  // Exclui um produto
  Future<void> _excluirProduto(int indice) async {

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text(
            'Deseja excluir "${_produtos[indice].produto}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && mounted) {
      setState(() {
        _produtos.removeAt(indice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papelaria'),
        centerTitle: true,
      ),

      body: _produtos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum produto cadastrado.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _produtos.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5);
              },
              itemBuilder: (context, index) {

                final produto = _produtos[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2_outlined),
                    ),

                    // Produto como título
                    title: Text(
                      produto.produto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Marca e categoria como informações
                    subtitle: Text(
                      'Marca: ${produto.marca}\n'
                      'Categoria: ${produto.categoria}',
                    ),

                    isThreeLine: true,

                    // Selecionar o registro também permite editar
                    onTap: () {
                      _abrirFormulario(indice: index);
                    },

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // Botão de edição
                        IconButton(
                          tooltip: 'Editar',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            _abrirFormulario(indice: index);
                          },
                        ),

                        // Botão de exclusão
                        IconButton(
                          tooltip: 'Excluir',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _excluirProduto(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // Botão para cadastrar
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _abrirFormulario();
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
    );
  }
}

// Tela de cadastro e edição
class FormularioProdutoPage extends StatefulWidget {

  final Produto? produto;

  const FormularioProdutoPage({
    super.key,
    this.produto,
  });

  @override
  State<FormularioProdutoPage> createState() =>
      _FormularioProdutoPageState();
}

class _FormularioProdutoPageState
    extends State<FormularioProdutoPage> {

  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  late final TextEditingController _produtoController;
  late final TextEditingController _marcaController;
  late final TextEditingController _categoriaController;

  @override
  void initState() {
    super.initState();

    // Preenche os campos quando estiver editando
    _produtoController = TextEditingController(
      text: widget.produto?.produto ?? '',
    );

    _marcaController = TextEditingController(
      text: widget.produto?.marca ?? '',
    );

    _categoriaController = TextEditingController(
      text: widget.produto?.categoria ?? '',
    );
  }

  @override
  void dispose() {
    _produtoController.dispose();
    _marcaController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  // Validação dos campos
  String? _validarCampo(String? valor, String campo) {

    if (valor == null || valor.trim().isEmpty) {
      return 'Preencha o campo $campo.';
    }

    return null;
  }

  // Salvar cadastro ou edição
  void _salvar() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final novoProduto = Produto(
      produto: _produtoController.text.trim(),
      marca: _marcaController.text.trim(),
      categoria: _categoriaController.text.trim(),
    );

    // Retorna o registro para a tela anterior
    Navigator.of(context).pop(novoProduto);
  }

  @override
  Widget build(BuildContext context) {

    final bool editando = widget.produto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar produto' : 'Novo produto',
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const Text(
                    'Informações do produto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo Produto
                  TextFormField(
                    controller: _produtoController,
                    decoration: const InputDecoration(
                      labelText: 'Produto',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    validator: (valor) {
                      return _validarCampo(valor, 'Produto');
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo Marca
                  TextFormField(
                    controller: _marcaController,
                    decoration: const InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (valor) {
                      return _validarCampo(valor, 'Marca');
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo Categoria
                  TextFormField(
                    controller: _categoriaController,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    validator: (valor) {
                      return _validarCampo(valor, 'Categoria');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Botão de salvar
                  FilledButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar registro'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
