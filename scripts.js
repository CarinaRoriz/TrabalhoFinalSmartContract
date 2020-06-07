var ganacheUrl = 'http://localhost:7545';
var contractAddress = '0x11c55982985adeeba31ec494a490cfe805be34f5';
var contractArray =    
    [
        {
            "constant": true,
            "inputs": [ 
                {
                    "name": "_id",
                    "type": "uint256"
                }
            ],
            "name": 'getNumeroVezesTocada',
            "outputs": [ 
                {
                    "name": "",
                    "type": "uint256"
                },
            ],
            "payable": false,
            "stateMutability": 'view',
            "type": 'function'
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "musicasPorPlataforma",
            "outputs": [
                {
                    "name": "id",
                    "type": "uint256"
                },
                {
                    "name": "idMusica",
                    "type": "uint256"
                },
                {
                    "name": "contador",
                    "type": "uint256"
                },
                {
                    "name": "plataforma",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "musicas",
            "outputs": [
                {
                    "name": "id",
                    "type": "uint256"
                },
                {
                    "name": "artista",
                    "type": "address"
                },
                {
                    "name": "plataforma",
                    "type": "address"
                },
                {
                    "name": "nomeMusica",
                    "type": "string"
                },
                {
                    "name": "preco",
                    "type": "uint256"
                },
                {
                    "name": "contador",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getQuantidadeMusicas",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_nomeMusica",
                    "type": "string"
                },
                {
                    "name": "_preco",
                    "type": "uint256"
                }
            ],
            "name": "cadastrarMusica",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_id",
                    "type": "uint256"
                },
                {
                    "name": "plataforma",
                    "type": "address"
                }
            ],
            "name": 'getNumeroTocadasPorPlatatorma',
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": 'view',
            "type": 'function'
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_id",
                    "type": "uint256"
                }
            ],
            "name": "tocaMusica",
            "outputs": [],
            "payable": true,
            "stateMutability": "payable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_id",
                    "type": "uint256"
                }
            ],
            "name": "getMusica",
            "outputs": [
                {
                    "name": "",
                    "type": "string"
                },
                {
                    "name": "",
                    "type": "uint256"
                },
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getMusicasDisponiveis",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256[]"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
    ];
function handleMusicData(){
    contract.getMusicasDisponiveis(function(error, result){
		if (!error) {
			var musicas = [];
			$.each(result, function(index, value) {
	  			contract.getMusica(value, function(error, result){					  
					if (!error) {
						if(!musicas.includes(result[0])) {
                            var card = '<div class="col-3">' +
                            '  <div class="card">' + 
							'   <div class="card-body">' + 
							`    <h5 class="card-title">${result[0]}</h5>` + 
							`    <h6 class="card-subtitle mb-2 text-muted">ETH${web3.fromWei(result[1], "ether")}</h6>`; 
							
								if(result[2]>0)
									card+= `<span>Tocada ${result[2]} vez${(result[2]>1)?'es':''}</span>`
								else
									card+= '<span>Ainda não tocada</span>'

								card+='</div></div></div>';
								$('#musicas').append(card);
							
							musicas.push(result[0]);
						}
					} else {
                        showError(error);
						console.log(error);
					}
				});
			});
		} else {
            showError(error);
			console.log(error);
		}
    });	

}

function getAvailableMusics() {//mostrando as musicas disponíveis
    contract.getMusicasDisponiveis(function(error, result){
        if (!error) {
            $('#musicas').html("");
            $.each(result, function(index, value) {
                contract.getMusica(value, function(error, result){
                    if (!error) {
                        contract.getNumeroTocadasPorPlatatorma(value,$('#carteira').val(), function(error, tocada){
                            
                            var card = '<div class="col-3">' +
                                '  <div class="card">' + 
                                '  <div class="card-body">' + 
                                `    <h5 class="card-title">${result[0]}</h5>` + 
                                `    <h6 class="card-subtitle mb-2 text-muted">ETH${web3.fromWei(result[1], "ether")}</h6>` + 
                                `    <button type="button" class="btn btn-info" onclick="play(${value})">Tocar</button><br>`; 
                                var qtdeTocada = tocada.toNumber();              
                                if(qtdeTocada>0)
                                    card+= `<span>Tocada ${qtdeTocada} vez${(qtdeTocada>1)?'es':''} na plataforma</span>`
                                else
                                    card+= '<span>Ainda não tocada na plataforma</span>'
                                '</div></div></div>';
                                $('#musicas').append(card);       
                        });

                    } else {
                        showError(error);
                        console.log(error);
                    }
                });
            });
        } else {
            showError(error);
            console.log(error);
        }
    });

}

function play(id) {
    contract.getMusica(id, function(error, result){
        if (!error) {
            try{
                contract.tocaMusica(id, {from: $('#carteira').val(), value: result[1], gas: 3000000});
                showSuccess('Transação realizada com sucesso!');
            }
            catch(erro){
                showError(erro);
            }
        } else {
            console.log(error);
        }
        location.reload();
    });
    
}

function showSuccess(msg){
    $('#divAlerta').show();
    $('#divAlerta').removeClass('alert-danger');
    $('#divAlerta').addClass('alert-success');
    $('#spanAlerta').text(msg);
    setTimeout(function(){
        $('#divAlerta').hide();       
    }, 3000);    
}

function showError(erro){
    $('#divAlerta').show();
        $('#divAlerta').removeClass('alert-success');
        $('#divAlerta').addClass('alert-danger');
        $('#spanAlerta').text(erro);
    setTimeout(function(){
        $('#divAlerta').hide()
    }, 3000);   
}