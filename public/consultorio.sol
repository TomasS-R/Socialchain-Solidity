// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Consultorio {
    struct Consulta {
        uint numeroSocio;
        uint fechaHora;
        uint valorConsulta;
        address validacionPaciente;
        address validacionOS;
        string observaciones;
        uint estado;
    }

    struct Usuario{
        address usuario;
        string clave;
        uint rol;
    }

    event ConsultaRegistrada(bytes32 indexed id, uint indexed numeroSocio, uint fechaHora, uint valorConsulta, address validacionPaciente, address validacionOS, string observaciones, uint estado);

    // Guardar la consulta por ID único y permite que otros contratos accedan a la info mediante public
    mapping(bytes32 => Consulta) public consultas;
    mapping(bytes32 => Usuario) public usuarios;

    function registrarConsulta(uint _numeroSocio, uint _fechaHora, uint _valorConsulta, address _validacionPaciente, address _validacionOS, string memory _observaciones, uint _estado) public {
        // Creo identificador unico
        bytes32 id = keccak256(abi.encodePacked(_numeroSocio, _fechaHora));
        // Almaceno los datos 
        consultas[id] = Consulta(_numeroSocio, _fechaHora, _valorConsulta, _validacionPaciente, _validacionOS, _observaciones, _estado);

        // Emit the event
        emit ConsultaRegistrada(id, _numeroSocio, _fechaHora, _valorConsulta, _validacionPaciente, _validacionOS, _observaciones, _estado);
    }

    function obtenerConsulta(bytes32 _id) public view returns (Consulta memory) {
        return consultas[_id];
    }

    function obtenerConsultaPorDatos(uint _numeroSocio, uint _fechaHora) public pure returns (bytes32 _id) {
        bytes32 id = keccak256(abi.encodePacked(_numeroSocio, _fechaHora));
        return id;
    }

    function registrarUsuario(address _usuario, string memory _clave, uint _rol) public {
        // Creo identificador unico
        bytes32 id = keccak256(abi.encodePacked(_usuario, _clave));
        // Almaceno los datos 
        usuarios[id] = Usuario(_usuario, _clave, _rol);
    }

    function validarUsuario(address _usuario, string memory _clave) public view returns (uint rol) {
        
        bytes32 id = keccak256(abi.encodePacked(_usuario, _clave));
        
        Usuario storage usuario = usuarios[id];

        require(keccak256(abi.encodePacked(_clave)) == keccak256(abi.encodePacked(usuario.clave)), "Invalid password");

        return usuario.rol;
    }

    function pacienteValidarConsulta(uint _numeroSocio, uint _fechaHora) public returns (bytes32 _id) {
    bytes32 id = keccak256(abi.encodePacked(_numeroSocio, _fechaHora));
    address pacienteAddress = msg.sender;  // Assuming you want to store the address of the caller
    
    // Retrieve the existing Consulta and update only the validacionPaciente field
    Consulta storage consulta = consultas[id];
    consulta.validacionPaciente = pacienteAddress;
    consulta.estado = 1;
    return id;
}

function osValidarConsulta(uint _numeroSocio, uint _fechaHora) public returns (bytes32 _id) {
    bytes32 id = keccak256(abi.encodePacked(_numeroSocio, _fechaHora));
    address osAddress = msg.sender;  // Assuming you want to store the address of the caller
    
    // Retrieve the existing Consulta and update only the validacionPaciente field
    Consulta storage consulta = consultas[id];
    consulta.validacionOS = osAddress;
    consulta.estado = 2;
    
    return id;
}

}