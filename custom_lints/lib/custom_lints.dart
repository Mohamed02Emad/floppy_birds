import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart' as listener;
import 'package:custom_lint_builder/custom_lint_builder.dart';

class MethodLineLimitLint extends DartLintRule {
  static const int maxLines = 10;

  const MethodLineLimitLint() : super(code: _code);

  static const _code = LintCode(
    name: 'method_too_long',
    problemMessage:
        'This method has too many lines. Maximum allowed: $maxLines',
    correctionMessage:
        'Consider refactoring this method into smaller functions.',
    errorSeverity: error.ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    listener.ErrorReporter reporter,
    CustomLintContext context,
  ) {
    resolver.getResolvedUnitResult().then((result) {
      result.unit.visitChildren(_MethodVisitor(reporter, resolver));
    });
  }
}

class _MethodVisitor extends RecursiveAstVisitor<void> {
  final listener.ErrorReporter reporter;
  final CustomLintResolver resolver;
  _MethodVisitor(this.reporter, this.resolver);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _checkFunctionBody(node.body, node.returnType);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _checkFunctionBody(node.functionExpression.body, node.returnType);
    super.visitFunctionDeclaration(node);
  }

  void _checkFunctionBody(FunctionBody body, TypeAnnotation? returnType) {
    final sourceRange = body.sourceRange;

    // Get the line information from the source
    final lineInfo = resolver.lineInfo;
    // Calculate the number of lines
    final startLine = lineInfo.getLocation(sourceRange.offset).lineNumber;
    final endLine = lineInfo.getLocation(sourceRange.end).lineNumber;
    final lines = endLine - startLine + 1;
    if (lines > MethodLineLimitLint.maxLines &&
        returnType?.type?.getDisplayString() != "Widget") {
      reporter.reportError(
        error.AnalysisError.forValues(
          source: resolver.source,
          offset: body.offset,
          length: body.length,
          errorCode: MethodLineLimitLint._code,
          message: '${MethodLineLimitLint._code.problemMessage} ($lines lines)',
        ),
      );
    }
  }
}

PluginBase createPlugin() => _CustomLintPlugin();

class _CustomLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    MethodLineLimitLint(),
  ];
}
