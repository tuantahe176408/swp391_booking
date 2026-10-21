/**
 * UC27 - AI Chatbox Widget
 * IIFE: no global variables. Reads context path from <meta name="contextPath">.
 * Checks /chat?check=enabled before revealing the widget.
 * Uses ES2015 Promise (.then/.catch) — no .finally() to keep IE11/older-Android compat.
 */
(function () {
    'use strict';

    var ctx = (document.querySelector('meta[name="contextPath"]') || {}).content || '';

    // ── DOM references (set after init) ─────────────────────────────
    var toggleBtn, panel, messagesDiv, input, sendBtn;

    // ── Initialise ────────────────────────────────────────────────────
    function init() {
        toggleBtn   = document.getElementById('chatbox-toggle-btn');
        panel       = document.getElementById('chatbox-panel');
        messagesDiv = document.getElementById('chatbox-messages');
        input       = document.getElementById('chatbox-input');
        sendBtn     = document.getElementById('chatbox-send-btn');

        if (!toggleBtn || !panel) return; // widget HTML not present

        // Check if AI backend is enabled
        fetch(ctx + '/chat?check=enabled', { method: 'GET' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data && data.enabled) {
                    toggleBtn.classList.add('cb-visible');
                    bindEvents();
                }
            })
            .catch(function () { /* AI disabled or network error — stay hidden */ });
    }

    // ── Event binding ─────────────────────────────────────────────────
    function bindEvents() {
        toggleBtn.addEventListener('click', function () {
            var isOpen = panel.classList.toggle('cb-open');
            if (isOpen) {
                input.focus();
                scrollToBottom();
            }
        });

        document.getElementById('chatbox-close-btn').addEventListener('click', function () {
            panel.classList.remove('cb-open');
        });

        sendBtn.addEventListener('click', sendMessage);
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
        });
    }

    // ── Send message ──────────────────────────────────────────────────
    function sendMessage() {
        var text = input.value.trim();
        if (!text) return;

        appendMessage(text, 'user');
        input.value = '';
        input.disabled = true;
        sendBtn.disabled = true;

        var typingEl = appendTyping();

        // POST as application/x-www-form-urlencoded
        // Re-enable helper — called from both success and error paths (avoids .finally() ES2018 dep)
        function reenable() {
            input.disabled = false;
            sendBtn.disabled = false;
            input.focus();
        }

        fetch(ctx + '/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(text)
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            removeTyping(typingEl);
            appendMessage(data.reply, data.error ? 'error' : 'bot');
            reenable();
        })
        .catch(function () {
            removeTyping(typingEl);
            appendMessage('Không thể kết nối tới trợ lý AI. Vui lòng thử lại.', 'error');
            reenable();
        });
    }

    // ── DOM helpers ───────────────────────────────────────────────────
    function appendMessage(text, type) {
        var div = document.createElement('div');
        div.className = 'cb-msg cb-msg-' + type;
        div.textContent = text;
        messagesDiv.appendChild(div);
        scrollToBottom();
        return div;
    }

    function appendTyping() {
        var div = document.createElement('div');
        div.className = 'cb-typing';
        div.innerHTML = '<span></span><span></span><span></span>';
        messagesDiv.appendChild(div);
        scrollToBottom();
        return div;
    }

    function removeTyping(el) {
        if (el && el.parentNode) el.parentNode.removeChild(el);
    }

    function scrollToBottom() {
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    // ── Boot ──────────────────────────────────────────────────────────
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();
