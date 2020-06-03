pragma solidity ^0.4.18;

contract ExecutarMusica {

  struct Musica {
    uint id;
    address artista; //seller
    //address gravadora; //seller
    address plataforma; //buyer
    string nomeMusica;
    uint256 preco;
    mapping (address => int) execucaoPlataforma; //armazenar quantidade de execução da musica por plataforma
  }

  mapping (uint => Musica) public musicas;
  uint musicasCount;

  //cadastrar música
  function cadastrarMusica(string _nomeMusica, uint256 _preco) public {
    musicasCount++;

    musicas[musicasCount] = Musica(
      musicasCount,
      msg.sender,
      0x0,
      _nomeMusica,
      _preco,
      0
    );
  }

  //quantidade de itens anunciados
  function getNumberO musicas() public view returns (uint) {
    return musicasCount;
  }

  //retorna os itens ainda a venda
  function ge musicasForSale() public view returns (uint[]) {
    uint[] memory articleIds = new uint[](musicasCount);

    uint numberO musicasForSale = 0;
    for(uint i = 1; i <= musicasCount; i++) {
      if musicas[i].buyer == 0x0) { //se não tiver comprador
        articleIds[numberO musicasForSale] = musicas[i].id;
        numberO musicasForSale++;
      }
    }

    //copia para array de itens
    uint[] memory forSale = new uint[](numberO musicasForSale);
    for(uint j = 0; j < numberO musicasForSale; j++) {
      forSale[j] = articleIds[j];
    }

    return forSale;
  }

  function getArticle(uint _id) public view returns (string, string, uint256) {
    //deve existir
    require(_id > 0 && _id <= musicasCount);

    Article storage article = musicas[_id];

    return (article.name, article.description, article.price);
  }

  //comprar um item
  function buyArticle(uint _id) payable public {
    //deve ter itens a venda
    require(musicasCount > 0);

    //deve existir
    require(_id > 0 && _id <= musicasCount);

    Article storage article = musicas[_id];

    //não foi vendido ainda
    require(article.buyer == 0X0);

    //não pode ser do próprio comprador
    require(msg.sender != article.seller);

    //valor enviado deve ser igual ao do valor anunciado
    require(msg.value == article.price);

    //atualiza comprador
    article.buyer = msg.sender;

    //paga vendedor
    article.seller.transfer(msg.value);
  }
}
