class Board{
  final String bid;
  final String bnm;

  Board({
    this.bid,
    this.bnm
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      bid : json['bid'],
      bnm : json['bnm'],
    );
  }
}