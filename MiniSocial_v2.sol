// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MiniSocial {
    struct Post {
        string message;
        address author;
        uint likes;
        uint dislikes;
        uint timestamp;
        uint lastModified;
    }

    Post[] public posts;
    mapping(uint => mapping(address => bool)) private likedPosts; // Pour enregistrer les likes par utilisateur et par post
    mapping(uint => mapping(address => bool)) private dislikedPosts;

    // Se connecter et publier un post
    function publishPost(string memory _message) public {
        Post memory newPost = Post({
            message: _message,
            author: msg.sender,
            likes: 0,
            dislikes: 0,
            timestamp: block.timestamp,
            lastModified: 0
        });
        posts.push(newPost);
    }

    // Récupérer les détails d'un post avec la date de création et la dernière modification
    function getPost(uint index) public view returns (
        string memory, address, uint, uint, uint, uint
    ) {
        Post storage post = posts[index];
        return (post.message, post.author, post.likes, post.dislikes, post.timestamp, post.lastModified);
    }

    // Modifier un post, accessible uniquement par le propriétaire
    function editPost(uint index, string memory _newMessage) public {
        Post storage post = posts[index];
        require(msg.sender == post.author, "Only the author can edit this post");
        post.message = _newMessage;
        post.lastModified = block.timestamp;
    }

    // Like un post si l'utilisateur ne l'a pas déjà aimé
    function likePost(uint index) public {
        require(!likedPosts[index][msg.sender], "Already liked this post");
        likedPosts[index][msg.sender] = true;
        posts[index].likes++;
        // Remove dislike if user had disliked before
        if (dislikedPosts[index][msg.sender]) {
            dislikedPosts[index][msg.sender] = false;
            posts[index].dislikes--;
        }
    }

    // Dislike un post si l'utilisateur ne l'a pas déjà désaimé
    function dislikePost(uint index) public {
        require(!dislikedPosts[index][msg.sender], "Already disliked this post");
        dislikedPosts[index][msg.sender] = true;
        posts[index].dislikes++;
        // Remove like if user had liked before
        if (likedPosts[index][msg.sender]) {
            likedPosts[index][msg.sender] = false;
            posts[index].likes--;
        }
    }

    // Récupérer le nombre total de posts publiés
    function getTotalPosts() public view returns (uint) {
        return posts.length;
    }
}
