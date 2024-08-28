
enum PaymentSDKNetworks {
  amex,
  pagoBancomat,
  bancontact,
  cartesBancaires,
  chinaUnionPay,
  dankort,
  discover,
  eftpos,
  electron,
  elo,
  idCredit,
  interac,
  JCB,
  mada,
  maestro,
  masterCard,
  mir,
  privateLabel,
  quicPay,
  suica,
  visa,
  vPay,
  barcode,
  girocard,
  waon,
  nanaco,
  postFinance,
  tmoney,
  meeza,
}

extension PaymentSDKNetworksExtension on PaymentSDKNetworks {
  String get name {
    switch (this) {
      case PaymentSDKNetworks.amex:
        return "amex";
      case PaymentSDKNetworks.pagoBancomat:
        return "pagoBancomat";
      case PaymentSDKNetworks.bancontact:
        return "bancontact";
      case PaymentSDKNetworks.cartesBancaires:
        return "cartesBancaires";
      case PaymentSDKNetworks.chinaUnionPay:
        return "chinaUnionPay";
      case PaymentSDKNetworks.dankort:
        return "dankort";
      case PaymentSDKNetworks.discover:
        return "discover";
      case PaymentSDKNetworks.eftpos:
        return "eftpos";
      case PaymentSDKNetworks.electron:
        return "electron";
      case PaymentSDKNetworks.elo:
        return "elo";
      case PaymentSDKNetworks.idCredit:
        return "idCredit";
      case PaymentSDKNetworks.interac:
        return "interac";
      case PaymentSDKNetworks.JCB:
        return "JCB";
      case PaymentSDKNetworks.mada:
        return "mada";
      case PaymentSDKNetworks.maestro:
        return "maestro";
      case PaymentSDKNetworks.masterCard:
        return "masterCard";
      case PaymentSDKNetworks.mir:
        return "mir";
      case PaymentSDKNetworks.privateLabel:
        return "privateLabel";
      case PaymentSDKNetworks.quicPay:
        return "quicPay";
      case PaymentSDKNetworks.suica:
        return "suica";
      case PaymentSDKNetworks.visa:
        return "visa";
      case PaymentSDKNetworks.vPay:
        return "vPay";
      case PaymentSDKNetworks.barcode:
        return "barcode";
      case PaymentSDKNetworks.girocard:
        return "girocard";
      case PaymentSDKNetworks.waon:
        return "waon";
      case PaymentSDKNetworks.nanaco:
        return "nanaco";
      case PaymentSDKNetworks.postFinance:
        return "postFinance";
      case PaymentSDKNetworks.tmoney:
        return "tmoney";
      case PaymentSDKNetworks.meeza:
        return "meeza";
      default:
        return "unknown";
    }
  }
}
