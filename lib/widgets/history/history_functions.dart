import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/services/convert.dart';
import 'package:flutter/material.dart';

class HistoryFunctions {
  static Widget tableText(String text,
      {double? size, bool? bold = false, bool color = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: bold! ? FontWeight.bold : FontWeight.normal,
              fontSize: (size != null) ? size : 16,
              color: (color) ? Colors.black : Colors.white)),
    );
  }

  static List<TableRow> buildTableRows(int qtdRows, List visitsData) {
    return List.generate(
      qtdRows, // Substitua com o tamanho da sua lista de dados
      (index) => TableRow(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: index % 2 == 0 ? StdValues.bkgFieldGrey : Colors.white,
        ),
        children: [
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(visitsData[index]['operators']['name'])),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(visitsData[index]['visitors']['name'])),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(Convert.formatDate(visitsData[index]['date']))),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(visitsData[index]['time'])),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(visitsData[index]['authorizedBy'])),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: tableText(
                visitsData[index]['goal'],
              )),
        ],
      ),
    );
  }

  static TableRow tableColumns() {
    return TableRow(
        decoration: BoxDecoration(
            color: StdValues.bkgBlue, borderRadius: BorderRadius.circular(6)),
        children: [
          tableText('Operador', color: false, bold: true, size: 18),
          tableText('Visitante', color: false, bold: true, size: 18),
          tableText('Data', color: false, bold: true, size: 18),
          tableText('Hora', color: false, bold: true, size: 18),
          tableText('Autorizado por', color: false, bold: true, size: 18),
          tableText('Finalidade', color: false, bold: true, size: 18),
        ]);
    // ...buildTableRows(visits.length, visits)
  }
}
