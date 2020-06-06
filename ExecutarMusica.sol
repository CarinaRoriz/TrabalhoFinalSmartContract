pragma solidity ^0.4.18;

contract ExecutarMusica {

  struct Musica {
    uint id;
    address artista; //seller
    address plataforma; //buyer
    string nomeMusica;
    uint256 preco;
    //mapping (address => int) execucoesPlataforma; //armazenar quantidade de execução da musica por plataforma
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
      _preco
      //0
    );
  }

  //quantidade de músicas anunciadas
  function getQuantidadeMusicas() public view returns (uint) {
    return musicasCount;
  }

  //retorna as músicas ainda disponíveis
  function getMusicasDisponiveis() public view returns (uint[]) {
    uint[] memory musicaIds = new uint[](musicasCount);

    uint numeroMusicasDisponiveis = 0;
    for(uint i = 1; i <= musicasCount; i++) {
      if(musicas[i].plataforma == 0x0) {//se não tiver pagador
        musicaIds[numeroMusicasDisponiveis] = musicas[i].id;
        numeroMusicasDisponiveis++;
      }
    }

    //copia para array de musicas disponiveis
    uint[] memory disponiveis = new uint[](numeroMusicasDisponiveis);
    for(uint j = 0; j < numeroMusicasDisponiveis; j++) {
      disponiveis[j] = musicaIds[j];
    }

    return disponiveis;
  }

  function getMusica(uint _id) public view returns (string, uint256) {
    //deve existir
    require(_id > 0 && _id <= musicasCount);
    
    Musica storage musica = musicas[_id];
    return (musica.nomeMusica, musica.preco);
  }

  //tocar uma musica
  function tocaMusica(uint _id) public payable {
    //deve ter musicas disponiveis
    require(musicasCount > 0);

    //deve existir
    require(_id > 0 && _id <= musicasCount);

    Musica storage musica = musicas[_id];

    //não foi tocada ainda
    //require(musica.plataforma == 0X0, 'Música nunce tocada');

    //não pode ser do próprio artista
    require(msg.sender != musica.artista);

    //valor enviado deve ser igual ao do valor anunciado
    require(msg.value == musica.preco);

    //atualiza plataforma
    musica.plataforma = msg.sender;

    //paga artista
    musica.artista.transfer(msg.value);
  }
}
