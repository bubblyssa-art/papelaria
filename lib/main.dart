
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const PapelariaApp());
}

// Modelo do produto
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

// Cores e configuração do aplicativo
class PapelariaApp extends StatelessWidget {
  const PapelariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papelaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7057A3),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF302942),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const ListaProdutosPage(),
    );
  }
}

// Tela principal de listagem
class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({super.key});

  @override
  State<ListaProdutosPage> createState() =>
      _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {

  // Lista de produtos armazenada em memória
  final List<Produto> _produtos = [
    const Produto(
      produto: 'Caderno',
      marca: 'Tilibra',
      categoria: 'Escolar',
    ),
  ];

  // Abrir formulário para cadastrar ou editar
  Future<void> _abrirFormulario({int? indice}) async {

    final Produto? produtoAtual =
        indice == null ? null : _produtos[indice];

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

    if (resultado != null && mounted) {
      setState(() {
        if (indice == null) {
          _produtos.add(resultado);
        } else {
          _produtos[indice] = resultado;
        }
      });
    }
  }

  // Excluir produto
  Future<void> _excluirProduto(int indice) async {

    final produto = _produtos[indice];

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Excluir produto?'),
          content: Text(
            'Deseja realmente excluir "${produto.produto}"?',
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

  // Cartão de cada produto
  Widget _cartaoProduto(Produto produto, int indice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEAE5F1),
        ),
      ),
      child: Row(
        children: [

          // Ícone do produto
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBF8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Color(0xFF7057A3),
            ),
          ),

          const SizedBox(width: 14),

          // Informações do produto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.produto,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302942),
                  ),
                ),

                const SizedBox(height: 9),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    EtiquetaProduto(
                      icone: Icons.sell_outlined,
                      texto: produto.marca,
                    ),
                    EtiquetaProduto(
                      icone: Icons.category_outlined,
                      texto: produto.categoria,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Botões de edição e exclusão
          IconButton(
            tooltip: 'Editar',
            onPressed: () {
              _abrirFormulario(indice: indice);
            },
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF7057A3),
              backgroundColor: const Color(0xFFF0EBF8),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),

          IconButton(
            tooltip: 'Excluir',
            onPressed: () {
              _excluirProduto(indice);
            },
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFFCE5555),
              backgroundColor: const Color(0xFFFFEEEE),
            ),
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }

  // Mensagem quando não existem produtos
  Widget _estadoVazio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEAE5F1),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 55,
            color: Color(0xFFB7AACD),
          ),
          const SizedBox(height: 15),
          const Text(
            'Nenhum produto cadastrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Clique em Novo produto para começar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBF8),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: Color(0xFF7057A3),
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Papelaria',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'GESTÃO DE PRODUTOS',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                22, 28, 22, 100,
              ),
              children: [

                const Text(
                  'Seus produtos',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302942),
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Gerencie os produtos cadastrados na sua papelaria.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777180),
                  ),
                ),

                const SizedBox(height: 23),

                // Resumo da quantidade de produtos
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7057A3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.18,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_produtos.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Produtos cadastrados',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 27),

                const Text(
                  'Lista de produtos',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF302942),
                  ),
                ),

                const SizedBox(height: 14),

                if (_produtos.isEmpty)
                  _estadoVazio()
                else
                  ...List.generate(
                    _produtos.length,
                    (indice) => _cartaoProduto(
                      _produtos[indice],
                      indice,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // Botão para novo cadastro
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _abrirFormulario();
        },
        backgroundColor: const Color(0xFF7057A3),
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo produto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Etiquetas de marca e categoria
class EtiquetaProduto extends StatelessWidget {

  final IconData icone;
  final String texto;

  const EtiquetaProduto({
    super.key,
    required this.icone,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
            size: 14,
            color: const Color(0xFF7057A3),
          ),
          const SizedBox(width: 5),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5D536E),
            ),
          ),
        ],
      ),
    );
  }
}

// Formulário de cadastro e edição
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

  // Salvar produto
  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final novoProduto = Produto(
      produto: _produtoController.text.trim(),
      marca: _marcaController.text.trim(),
      categoria: _categoriaController.text.trim(),
    );

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFEAE5F1),
                  ),
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      // Cabeçalho do formulário
                      const CircleAvatar(
                        radius: 27,
                        backgroundColor: Color(0xFFF0EBF8),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          color: Color(0xFF7057A3),
                          size: 27,
                        ),
                      ),

                      const SizedBox(height: 17),

                      Text(
                        editando
                            ? 'Editar informações'
                            : 'Cadastrar produto',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF302942),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        editando
                            ? 'Atualize as informações do produto.'
                            : 'Preencha os campos para adicionar um produto.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF777180),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Campo Produto
                      TextFormField(
                        controller: _produtoController,
                        textInputAction: TextInputAction.next,
                        decoration: _decoracaoCampo(
                          'Produto',
                          Icons.inventory_2_outlined,
                          'Ex.: Caderno universitário',
                        ),
                        validator: (valor) {
                          return _validarCampo(valor, 'Produto');
                        },
                      ),

                      const SizedBox(height: 18),

                      // Campo Marca
                      TextFormField(
                        controller: _marcaController,
                        textInputAction: TextInputAction.next,
                        decoration: _decoracaoCampo(
                          'Marca',
                          Icons.sell_outlined,
                          'Ex.: Tilibra',
                        ),
                        validator: (valor) {
                          return _validarCampo(valor, 'Marca');
                        },
                      ),

                      const SizedBox(height: 18),

                      // Campo Categoria
                      TextFormField(
                        controller: _categoriaController,
                        textInputAction: TextInputAction.done,
                        decoration: _decoracaoCampo(
                          'Categoria',
                          Icons.category_outlined,
                          'Ex.: Escolar',
                        ),
                        validator: (valor) {
                          return _validarCampo(valor, 'Categoria');
                        },
                      ),

                      const SizedBox(height: 28),

                      // Botões
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_rounded),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          foregroundColor: const Color(0xFF7057A3),
                          side: const BorderSide(
                            color: Color(0xFF7057A3),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      FilledButton.icon(
                        onPressed: _salvar,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Salvar produto'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF7057A3),
                          foregroundColor: Colors.white,
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
        ),
      ),
    );
  }

  // Aparência dos campos do formulário
  InputDecoration _decoracaoCampo(
    String titulo,
    IconData icone,
    String dica,
  ) {
    return InputDecoration(
      labelText: titulo,
      hintText: dica,
      prefixIcon: Icon(icone),
      filled: true,
      fillColor: const Color(0xFFFAF9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE5DFED),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF7057A3),
          width: 1.6,
        ),
      ),
    );
  }
}
