pragma solidity ^0.4.18;

contract ExecutarMusica {

  struct Musica {
    uint id;
    uint idArtista;
    address artista; //seller
    string nomeMusica;
    uint256 preco;
    uint contador;
  }

  struct MusicasPorPlataforma {
    uint id;
    uint idMusica;
    uint contador;
    address plataforma;
  }

  struct Artista {
    uint id;
  }

  mapping (uint => Musica) public musicas;
  mapping (uint => MusicasPorPlataforma) public musicasPorPlataforma; //armazenar quantidade de execução da musica por plataforma
  mapping (address => Artista) public idArtistaList;

  uint artistasCount;
  uint musicasCount;
  uint musicasPlataformCount;

  //cadastrar música
  function cadastrarMusica(string _nomeMusica, uint256 _preco) public {
    //Verifica se a musica já existe
    require(!checkMusicExist(_nomeMusica, msg.sender));

    musicasCount++;

    //Inicializa música e contador geral para ela
    musicas[musicasCount] = Musica(
      musicasCount,
      getIdArtista(msg.sender),
      msg.sender,
      _nomeMusica,
      _preco,
      0
    );
  }

  //quantidade de músicas anunciadas
  function getQuantidadeMusicas() public view returns (uint) {
    return musicasCount;
  }

  //busca id interno do artista
  function getIdArtista(address artista) public view returns (uint) {
    if(idArtistaList[artista].id>0)
    {
      return(idArtistaList[artista].id);
    } else {
      artistasCount++;
      idArtistaList[artista] = Artista(
        artistasCount
      );
      return(artistasCount);
    }
  }

  //retorna as músicas disponíveis
  function getMusicasDisponiveis() public view returns (uint[]) {
    uint[] memory musicaIds = new uint[](musicasCount);

    uint numeroMusicasDisponiveis = 0;
    for(uint i = 1; i <= musicasCount; i++) {
      musicaIds[numeroMusicasDisponiveis] = musicas[i].id;
      numeroMusicasDisponiveis++;
    }
    return musicaIds;
  }

  //verifica se a música já existe
  function checkMusicExist(string musicaNome, address sender) public view returns (bool) {
    bytes32 nome = keccak256(bytes(musicaNome));
    for(uint i = 1; i <= musicasCount; i++){
      string storage nomeAtual = musicas[i].nomeMusica;
      bytes32 currentName = keccak256(bytes(nomeAtual));
      if(nome == currentName && sender==musicas[i].artista)
        return true;
    }
    return false;
  }

  function getMusica(uint _id) public view returns (string, uint256, uint, uint) {
    //deve existir
    require(_id > 0 && _id <= musicasCount);

    Musica storage musica = musicas[_id];
    return (musica.nomeMusica, musica.preco, musica.contador, musica.idArtista);
  }

  //tocar uma musica
  function tocaMusica(uint _id) public payable {
    //deve ter musicas disponiveis
    require(musicasCount > 0);

    //deve existir
    require(_id > 0 && _id <= musicasCount);

    Musica storage musica = musicas[_id];

    //não pode ser do próprio artista
    require(msg.sender != musica.artista);

    //valor enviado deve ser igual ao do valor anunciado
    require(msg.value == musica.preco);

    //paga artista
    musica.artista.transfer(msg.value);

    //incrementa o contador geral (independente da plataforma) para a música atual
    uint execucoesMusicaAtual = musica.contador;
    execucoesMusicaAtual++;
    musica.contador = execucoesMusicaAtual;

	  //busca lista de músicas da plataforma atual
    bool encontrouReg = false;
    for(uint i = 0; i < musicasPlataformCount; i++){
      if(musicasPorPlataforma[i].idMusica==_id && musicasPorPlataforma[i].plataforma==msg.sender){
        uint contador = musicasPorPlataforma[i].contador;
        contador++;
        musicasPorPlataforma[i].contador = contador;
        encontrouReg = true;
        break;
      }
    }
    //caso primeiro registro, inicializa
    if(!encontrouReg){
      musicasPlataformCount++;
      musicasPorPlataforma[musicasPlataformCount] = MusicasPorPlataforma(
        musicasPlataformCount,
        _id,
        1,
        msg.sender
      );
    }
  }

  function getNumeroTocadasPorPlatatorma(uint _id, address plataforma) public view returns (uint){
    //busca lista de músicas da plataforma atual
    for(uint i = 0; i <= musicasPlataformCount; i++){
      if(musicasPorPlataforma[i].idMusica==_id && musicasPorPlataforma[i].plataforma==plataforma){
        uint contador = musicasPorPlataforma[i].contador;
        return(contador);
      }
    }
    return(0);
  }

  function getNumeroVezesTocada(uint _id) public view returns (uint){
    return(musicas[_id].contador);
  }
}
